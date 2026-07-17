#!/usr/bin/env node

import fs from "node:fs";
import path from "node:path";

const [configArg, skillsArg] = process.argv.slice(2);
if (!configArg || !skillsArg) {
  console.error("usage: validate-skills-config.mjs <skills.sh.json> <skills-directory>");
  process.exit(2);
}

const configPath = path.resolve(configArg);
const skillsDir = path.resolve(skillsArg);
const config = JSON.parse(fs.readFileSync(configPath, "utf8"));
const schemaUrl = "https://skills.sh/schemas/skills.sh.schema.json";
const isObject = (value) => value !== null && typeof value === "object" && !Array.isArray(value);
const checkKeys = (value, allowed, label) => {
  const unexpected = Object.keys(value).filter((key) => !allowed.has(key));
  if (unexpected.length > 0) {
    throw new Error(`${label} has unsupported properties: ${unexpected.join(", ")}`);
  }
};

if (!isObject(config)) throw new Error("skills.sh.json must contain an object");
checkKeys(config, new Set(["$schema", "schema", "notGrouped", "groupings"]), "skills.sh.json");
if (config.$schema !== schemaUrl || (config.schema !== undefined && config.schema !== schemaUrl)) {
  throw new Error("skills.sh.json uses an unexpected schema");
}
if (config.notGrouped !== undefined && !["top", "bottom"].includes(config.notGrouped)) {
  throw new Error('skills.sh.json notGrouped must be "top" or "bottom"');
}
if (!Array.isArray(config.groupings) || config.groupings.length < 1 || config.groupings.length > 50) {
  throw new Error("skills.sh.json requires 1-50 groupings");
}

const listed = [];
for (const [index, grouping] of config.groupings.entries()) {
  const label = `skills.sh.json grouping ${index + 1}`;
  if (!isObject(grouping)) throw new Error(`${label} must be an object`);
  checkKeys(grouping, new Set(["title", "description", "skills"]), label);
  if (typeof grouping.title !== "string" || grouping.title.length < 1 || grouping.title.length > 120) {
    throw new Error(`${label} title must contain 1-120 characters`);
  }
  if (
    grouping.description !== undefined &&
    (typeof grouping.description !== "string" || grouping.description.length > 500)
  ) {
    throw new Error(`${label} description must contain at most 500 characters`);
  }
  if (
    !Array.isArray(grouping.skills) ||
    grouping.skills.length < 1 ||
    grouping.skills.length > 500 ||
    grouping.skills.some(
      (skill) => typeof skill !== "string" || skill.length < 1 || skill.length > 120,
    )
  ) {
    throw new Error(`${label} skills must contain 1-500 names of 1-120 characters`);
  }
  listed.push(...grouping.skills);
}

const discovered = fs
  .readdirSync(skillsDir, { withFileTypes: true })
  .filter(
    (entry) => entry.isDirectory() && fs.existsSync(path.join(skillsDir, entry.name, "SKILL.md")),
  )
  .map((entry) => entry.name)
  .sort();
if (new Set(listed).size !== listed.length || listed.sort().join("\n") !== discovered.join("\n")) {
  throw new Error("skills.sh.json must list every skill exactly once");
}
