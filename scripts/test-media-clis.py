#!/usr/bin/env python3
from __future__ import annotations

import base64
import importlib.util
import sys
import tempfile
from pathlib import Path
from types import ModuleType, SimpleNamespace

sys.dont_write_bytecode = True

REPO = Path(__file__).resolve().parent.parent


def load_module(name: str, path: Path) -> ModuleType:
    spec = importlib.util.spec_from_file_location(name, path)
    if spec is None or spec.loader is None:
        raise RuntimeError(f"Cannot load {path}")
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module


def assert_raises(expected: type[Exception], callback, contains: str) -> None:
    try:
        callback()
    except expected as error:
        if contains not in str(error):
            raise AssertionError(f"Expected {contains!r} in {error!r}") from error
    else:
        raise AssertionError(f"Expected {expected.__name__}")


def test_chatgpt_imagegen() -> None:
    chat = load_module(
        "chatgpt_imagegen",
        REPO / "skills/chatgpt-imagegen/scripts/generate_image.py",
    )

    secret_prompt = "private launch image with unreleased product name"

    class ProviderFailure(RuntimeError):
        status_code = 400
        code = "invalid_request"

    class FailingImages:
        def generate(self, **kwargs):
            raise ProviderFailure(f"provider echoed prompt: {kwargs['prompt']}")

    try:
        chat.call_image_api(
            SimpleNamespace(images=FailingImages()),
            "generate",
            {"model": "gpt-image-2", "prompt": secret_prompt, "n": 1},
        )
    except chat.ImageRequestError as error:
        rendered = str(error)
        assert secret_prompt not in rendered
        assert "ProviderFailure status=400 code=invalid_request" in rendered
        assert error.request_fields["prompt"] == f"<{len(secret_prompt)} chars>"
        assert not hasattr(error, "cause")
    else:
        raise AssertionError("Provider failure did not raise ImageRequestError")

    assert_raises(
        ValueError,
        lambda: chat.validate_request_options(
            mode="generate",
            model="dall-e-3",
            size="1024x1024",
            quality="hd",
            background=None,
            num_images=2,
            output_format="png",
            output_compression=None,
        ),
        "requires --num 1",
    )
    assert_raises(
        ValueError,
        lambda: chat.validate_request_options(
            mode="generate",
            model="gpt-image-2",
            size="1792x1024",
            quality="high",
            background=None,
            num_images=1,
            output_format="png",
            output_compression=None,
        ),
        "size must be one of",
    )
    assert_raises(
        ValueError,
        lambda: chat.validate_request_options(
            mode="generate",
            model="gpt-image-2",
            size="1024x1024",
            quality="high",
            background=None,
            num_images=1,
            output_format="png",
            output_compression=80,
        ),
        "requires --format jpeg or webp",
    )

    payload = b"fake-image-bytes"
    response = SimpleNamespace(
        data=[
            SimpleNamespace(
                b64_json=base64.b64encode(payload).decode(),
                url=None,
                revised_prompt="safe revised prompt",
            )
        ]
    )

    class RecordingImages:
        def __init__(self):
            self.generate_kwargs = None
            self.edit_kwargs = None

        def generate(self, **kwargs):
            self.generate_kwargs = kwargs
            return response

        def edit(self, **kwargs):
            assert kwargs["image"].read(1) == b"i"
            self.edit_kwargs = kwargs
            return response

    images = RecordingImages()
    original_create_client = chat.create_client
    chat.create_client = lambda: SimpleNamespace(images=images)
    try:
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            generated = root / "generated.png"
            revised = chat.generate_image(
                prompt="safe test prompt",
                output_path=str(generated),
                model="gpt-image-2",
                size="1024x1024",
                quality="low",
            )
            assert generated.read_bytes() == payload
            assert revised == "safe revised prompt"
            assert images.generate_kwargs["model"] == "gpt-image-2"
            assert images.generate_kwargs["prompt"] == "safe test prompt"

            source = root / "input.png"
            source.write_bytes(b"image")
            edited = root / "edited.png"
            chat.edit_image(
                prompt="safe edit prompt",
                input_paths=[str(source)],
                output_path=str(edited),
                model="gpt-image-2",
                size="1024x1024",
            )
            assert edited.read_bytes() == payload
            assert images.edit_kwargs["prompt"] == "safe edit prompt"
    finally:
        chat.create_client = original_create_client


def test_gemini_tts() -> None:
    tts = load_module(
        "gemini_tts",
        REPO / "skills/gemini-tts/scripts/generate_tts.py",
    )

    class ProviderFailure(RuntimeError):
        status_code = 429
        code = "resource_exhausted"

    secret_text = "private narration text"
    error = ProviderFailure(f"provider echoed input: {secret_text}")
    rendered = tts.safe_error_summary(error)
    assert secret_text not in rendered
    assert rendered == "ProviderFailure status=429 code=resource_exhausted"
    assert tts.chunk_text("First paragraph.\n\nSecond paragraph.") == [
        "First paragraph.\n\nSecond paragraph."
    ]
    assert_raises(ValueError, lambda: tts.chunk_text(""), "Input text is empty")


def main() -> None:
    test_chatgpt_imagegen()
    test_gemini_tts()
    print("media CLI boundary tests passed")


if __name__ == "__main__":
    main()
