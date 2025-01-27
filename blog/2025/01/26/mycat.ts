async function main() {
    let input : Deno.FsFile | any = Deno.stdin;

    if (Deno.args.length > 0) {
        input = await Deno.open(Deno.args[0]);
    }

    const decoder = new TextDecoder();

    // NOTE: the .readable function is available on both types of objects.
    for await (const chunk of input.readable) {
        console.log(decoder.decode(chunk));
    }
}

if (import.meta.main) main();