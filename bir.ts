#!/usr/bin/env deno
/*******************************************************************************
* Bing Image Ripper - compile links from Bing image searches into an HTML file *
* Copyright (C) 2018 Michael Wiseman                                           *
*                                                                              *
* This program is free software: you can redistribute it and/or modify it      *
* under the terms of the GNU General Public License as published by the Free   *
* Software Foundation, either version 3 of the License, or (at your option)    *
* any later version.                                                           *
*                                                                              *
* This program is distributed in the hope that it will be useful, but WITHOUT  *
* ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or        *
* FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for    *
* more details.                                                                *
*                                                                              *
* You should have received a copy of the GNU General Public License along with *
* this program.  If not, see <https://www.gnu.org/licenses/>.                  *
*******************************************************************************/

////////////////
// UNFINISHED //
////////////////

import jsdom from 'https://dev.jspm.io/jsdom'

let arg = Deno.args.join(" ");
console.log(arg);
let filename = Deno.args.join("-").concat(".html");
let search = Deno.args.join("+");

const encoder = new TextEncoder();
await Deno.writeFile(filename,
                     encoder.encode(`<!DOCTYPE html>\n<html>\n<head>\n<title>${arg}</title>\n</head>\n<body>\n`),
                     { create: true });
await Deno.writeFile(filename,
                     encoder.encode(`<h1>${arg}</h1>\n`),
                     { append: true });
await Deno.writeFile(filename,
                     encoder.encode("<br>\n"),
                     { append: true });
for (let i = 0; i <= 10; i++)
{
    let uri = `https://www.bing.com/images/async?q=${search}&first=${(150*i)+1}&count=150&safeSearch=off&size=wallpaper&qft=+filterui:age-lt525600`;
    // let uri = `https://www.bing.com/images/async?q=${search}&first=${(150*i)+1}&count=150&safeSearch=off&size=wallpaper`;
    let response = await fetch(uri);
    let document = await response.text();
    let doc = new jsdom(document);
    // content = doc.window.document.querySelector(".iusc").textContent;
    // console.log(doc);
    // for (let line of content)
    // {
    //     let ijs = line['m']; or line['m']['murl']
    //     let image = ijs['murl']
    //     await Deno.writeFile(filename, encoder.encode(image), { append: true });
    // }
}
await Deno.writeFile(filename,
                     encoder.encode("</body>\n</html>"),
                     { append: true });
