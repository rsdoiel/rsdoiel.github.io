import { parseArgs } from "jsr:@std/cli";
import { licenseText, releaseDate, releaseHash, version } from "./version.ts";
import { fmtHelp, helpText } from "./helptext.ts";

const appName = "mycat";

async function main() {
  const app = parseArgs(Deno.args, {
    alias: {
      help: "h",
      license: "l",
      version: "v",
    },
    default: {
      help: false,
      version: false,
      license: false,
    },
  });
  const args = app._;

  if (app.help) {
    console.log(fmtHelp(helpText, appName, version, releaseDate, releaseHash));
    Deno.exit(0);
  }
  if (app.license) {
    console.log(licenseText);
    Deno.exit(0);
  }
  if (app.version) {
    console.log(`${appName} ${version} ${releaseHash}`);
    Deno.exit(0);
  }

  let input: Deno.FsFile | any = Deno.stdin;

  // handle case of many file names
  if (args.length > 1) {
    for (const arg of args) {
      input = await Deno.open(`${arg}`);
      // NOTE: the .readable function is available on both types of objects.
      for await (const chunk of input.readable) {
        const decoder = new TextDecoder();
        console.log(decoder.decode(chunk));
      }
    }
    Deno.exit(0);
  }
  if (args.length > 0) {
    input = await Deno.open(Deno.args[0]);
  }
  // NOTE: the .readable function is available on both types of objects.
  for await (const chunk of input.readable) {
    const decoder = new TextDecoder();
    console.log(decoder.decode(chunk));
  }
}

if (import.meta.main) main();
