# WCA Document Creation Guide

Here you can learn how to create new documents for this repository or translate existing documents in the Educational Resources (`edudoc`) folder to other languages.

## Overview

There are two different folders, where we keep the source files: `documents` and `edudoc`. `documents` contains all minutes, motions, policies, finance documents and other important WCA documents that can be found on [this page](https://www.worldcubeassociation.org/documents). and `edudoc` contains educational resources made by the WQAC that can be found on [this page](https://www.worldcubeassociation.org/education).

The source folders contain Markdown files (`.md`) and any images used in them. During the build process, these source files get copied into the `build` branch and converted to `.pdf`. Finished PDF files can also be put in the source folders; the builder will simply copy them and leave them untouched during the build process. However, it's better to use `.md` files, since they can be edited easily.

## Creating a new document

### Markdown

If you would like to make a document for this repo, you will need to learn Markdown, but it only takes 10-20 minutes to learn and is super easy to get used to. Just search for a tutorial in your language and you'll be able to learn it very quickly. When editing Markdown files in this repo, **make sure** your text editor does not have automatic formatting enabled (e.g. the Prettier extension in VS Code).

### Pandoc syntax

There are a few Pandoc features that we use in our documents. One of them is embedding styling right inside of Markdown without using HTML. Here are a few examples:

```md
## First Header {.page-break-before}

## Second Header {.class .other-class}

## Third Header {.class custom-css-property=value}
```

Notice that classes have a . before them, but custom CSS doesn't. However, you should try to avoid custom CSS and stick to our existing classes. You can find a list of classes that we use at the bottom of this article. The `documents` folder uses the styles in `assets/style.css`, and `edudoc` uses `assets/edudoc-style.css`.

Another pandoc syntax that we use is a shortcut for div blocks, which are basically blocks of content that you can apply styling to. This is used in conjunction with the styling syntax mentioned above. Here is an example:

```md
::: {.page-break-before}
## This is a header that starts on a new page

Here is some text.
:::
```

You can use any number of colon characters, but there must be at least three at the start and three at the end. If you only want to specify one class, you can do so without using braces. Here is an example:

```md
::: indent
This is some text that is indented.
:::
```

### Custom shortcuts

We also have a couple custom shortcuts in our repo:

{logo} - inserts the path to the WCA logo in `assets/WCAlogo_notext.svg`. Do not try to write a relative path to this file from your document, simply insert the shortcut wherever you need it. Here's an example:

```md
![WCA Logo]({logo})
```

wca{...} - inserts URL to a page on the WCA website. Example: `wca{regulations/guidelines}` gets converted to `https://www.worldcubeassociation.org/regulations/guidelines/`.

wcadoc{...} - inserts URL to a document page on the WCA website (any page with `documents.` as the subdomain). Example: `wcadoc{documents/policies/external/Competition Requirements.pdf}` gets converted to `https://documents.worldcubeassociation.org/documents/policies/external/Competition Requirements.pdf`.

### Commonly-used elements

1. **Page breaks** - simply insert these two lines wherever you would like to add a page break.

```md
::: page-break-before
:::
```

You can also add the `page-break-before` class or the `page-break-after` class to an existing element. Here are a few examples:

```md
## Header with page break {.page-break-before}

::: {.indent .page-break-after}
This text is indented and adds a page break after.
:::

This text is on a new page.

<!-- This image is on yet another page -->
![](images/my-image.png){.page-break-before}
```

2. **Images**

Create a folder called `images` in the same folder as your document, and put your images in `images`. Then use this syntax to embed your images in the document:

```md
![](images/my-image1.png)

<!-- Images can also have styling applied to them -->
![](images/my-image2.jpg){.centered}
```

3. **Version labels** (documents folder only)

If you are making a document that needs a version label (e.g. a policy document), use this:

```md
### Version 1.0 {.version}
```

4. **Numbered lists** (documents folder only)

Correct syntax looks like this (each indent is simply 3 spaces):

```md
1. Example
   1. Example
   2. Example
      1. Example
   3. Example
2. Example
```

**DO NOT** leave empty lines between list items. The builder will then convert it to look like this in the output PDF:

```
1. Example
    1.1. Example
    1.2. Example
        1.2.1. Example
    1.3. Example
2. Example
```

5. **Indents** (edudoc folder only)

Use this syntax to indent a paragraph:

```md
::: indent
This is an indented paragraph.
:::
```

6. **Highlighted content boxes** (edudoc folder only)

Use this syntax to create a box around content that needs to be highlighted:

```md
::: {.box .example}
This is important content that needs to be highlighted.

Here is some more content.
:::
```

Use the `box` class together with one of these classes: example, attention, warning, important.

## Translating educational resources

Translated Educational Resources documents are located either in a sub-folder in the same folder as the English document, titled as the 2-letter [ISO language code](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes), or in the same folder as the English document, but with a `-[2-letter language code]` suffix. Examples: the Portuguese translation of the competition checklist organizer guideline is located in `edudoc/organizer-guidelines/pt/checklist.md`, the Armenian translation of the judge tutorial is located in `edudoc/judge-tutorial/judge-tutorial-am.md`. The former folder structure is used when each translation contains more than one file.

To translate a document, copy the English document to the right place and rename it if necessary. Then translate the document, while keeping all of the formatting the same (e.g. the styling, the tables, etc.). If you are translating a document that needs some of the images to be translated too, contact the WQAC at wqac@worldcubeassociation.org, asking them to create the translated image file(s) and including the translated pieces of text. The parts that need to be translated can be found in the `translate.txt` file in the document's main folder, and you can simply copy the text in that file and fill it out.

Once you are finished translating, either send the WQAC your `.md` file(s), asking them to create a PR that adds your new translation, or create the PR yourself and have a WQAC member approve it.

## Previewing rendered document and merging

This is how you can get a preview of the rendered documents:

1. Create a PR that adds/updates a document.
2. Wait for the pipeline to build the PDF(s) from the Markdown file(s). This is done automatically and should take around one minute.
3. You should see a message that says "All checks have passed" at the bottom of the PR. Click on "Show all checks" next to that message, and then click "Details".
4. Click "Summary" on the left side of the screen and click "build" in the Artifacts section to download all rendered PDFs.
5. Unzip the downloaded file, find the file(s) that you are working on, and make sure everything was rendered as expected. Pay especially close attention to the alignment of the content, and make sure there are no unexpected page breaks. If you are adding a translation, make sure things are consistent with the original English version.
6. You can continue iterating, making additional PRs, until the rendered documents look correct.

Once you have finalized everything and received an approving review, a WCA staff member will merge your PR, and eventually you will see your changes on the WCA website.

## Classes

| Class             | Explanation                                        | Availability |
| ----------------- | -------------------------------------------------- | ------------ |
| page-break-before | Inserts a page break before                        | Both         |
| page-break-after  | Inserts a page break after                         | Both         |
| text-center       | Aligns text in the middle                          | Documents    |
| version           | Styling for the version header                     | Documents    |
| bordered-image    | Adds a border to the image                         | Documents    |
| box               | Adds a bounding box around the content, centers the content inside and makes it bold. Used together with example, attention, warning, or important. | Edudoc       |
| example           | Adds a green background to the box                 | Edudoc       |
| attention         | Adds a yellow background to the box                | Edudoc       |
| warning           | Adds a light red background to the box             | Edudoc       |
| important         | Adds a dark red background to the box and prefixes the content inside with the word "IMPORTANT" | Edudoc       |
| centered          | Centers the content                                | Edudoc       |
| text-right        | Aligns text on the right                           | Edudoc       |
| text-left         | Aligns text on the left                            | Edudoc       |
| indent            | Indents the text                                   | Edudoc       |
