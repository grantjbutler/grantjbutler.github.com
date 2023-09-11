---
title: Making Tailwind and Publish Play Nice With Each Other
tags: blogging, tailwind, publish
summary: In which I make my website look decent.
---

I won't lie. I'm not a designer. I may have an intiution about whether something is designed well or not by looking at it, but if you asked me to make something from scratch, while I may be able to make something usable, it's certainly not going to be the best designed thing you've ever seen.

When it comes to web development, one of the first things I pull into a new project is [Tailwind](https://tailwindcss.com). It's a utility-first CSS framework with some solid defaults that makes it easy to build something that looks good, while not boxing you in to something that looks generic. For someone like me, it's a great tool for helping me build something that looks decent.

Most of the time, Tailwind gets integrated with other build tools, like webpack or vite, where the generation of your site's styles are just one piece of a larger build process, which may copy images around, compile Vue or React components into straight JavaScript, and more. For this site, though, we're using [Publish](https://github.com/johnsundell/Publish) as our static site generator, which doesn't leverage any of these build tools already as part of its site generation process. While we could pull one of them it, it'd be overkill since we wouldn't be using any of their other features.

Fortunately, in addition to the above integrations with existing frontend built tools, you can run Tailwind directly with a command line tool to generate styles from your source code. With just a little bit of work, we can wrap up calling out to their CLI tool into a `PublishingStep` to integrate Tailwind into the build pipeline for our Publish site.

## Installing Tailwind

Before we start writing any of the Swift code of our `PublishingStep`, we need to make sure that Tailwind is installed and properly configured. We can follow the [installations docs](https://tailwindcss.com/docs/installation) for their CLI tool, using the root directory of our Swift package as the location of our NPM package. Since we're following the structure of a Swift package for our code, and the structure of a Publish site for our content, we'll need to update our `tailwind.config.js` file to tell it where to look for styles.

```js
/** @type {import('tailwindcss').Config} */
module.exports = {
  content: [
    "./Sources/**/*.swift",
    "./Content/**/*.{md,html,js}"
  ],
  theme: {
    extend: {},
  },
  plugins: [],
}
```

The two places that we tell Tailwind to look for styles are our Swift files (so it can detect which styles we may be using in our site's theme), and our content files (so it can detect any styles in any of the Markdown, HTML, or JavaScript files we may write). This is what works for me for my site, so if you have other files that have Tailwind styles, make sure you add the paths to the config file.

With Tailwind's configuration updated, we can start working on writing the `PublishingStep` that'll invoke Tailwind.

## Building the `PublishingStep`

First things first, we need to import a few different targets. We need the `Publish` target, so we can get access to the API we need for creating this `PublishingStep`. We'll pull in the `ShellOut` target, to give us a streamlined interface to invoking command line executables, like the Tailwind CLI tool. Finally, we'll pull in the `Files` target to give us a set of convenience APIs for interacting with the filesystem.

With the targets imported, we can create the factory method for our `PublishingStep` that will invoke Tailwind:

```swift
import Files
import Publish
import ShellOut

extension PublishingStep {
    static func generateTailwindCSS(
        inputPath: Path = "Resources/styles.css",
        outputPath: Path = "styles.css"
    ) -> PublishingStep {
        .step(named: "Generate Tailwind CSS", body: { context in
            
        })
    }
}
```

This step takes in two arguments: the source CSS file that has the Tailwind directives in it, and an output file where the generated CSS should be put within Publish's `Output` folder.

Now we can start to fill in the body of our step to actually invoke Tailwind:

```swift
import Files
import Publish
import ShellOut

extension PublishingStep {
    static func generateTailwindCSS(
        inputPath: Path = "Resources/styles.css",
        outputPath: Path = "styles.css"
    ) -> PublishingStep {
        .step(named: "Generate Tailwind CSS", body: { context in
            try shellOut(
                to: "npx",
                arguments: ["tailwindcss", "-i", context.file(at: inputPath).path, "-o", context.outputFile(at: outputPath).path, "--minify"]
            )
        })
    }
}
```

Using the `shellOut` function provided by the `ShellOut` package, we run the `tailwindcss` command by way of `npx`, providing our source CSS file as the input path and the location where the generated CSS should live as the output path. We also tell Tailwind to minify the CSS, to reduce the size of the generated file. However, if we include this step in our build pipeline and try to run it, we'll run into a few issues.

First, `outputFile(at:)` actually expects the file at the given path to exist. Even if all we're wanting to do is determine the path to a file in Publish's `Output` directory so we can give it to Tailwind, the method will still check to see if the file exists and throw an error if it doesn't. We can work around this by creating the file ourselves before invoking Tailwind by utilizing the `createOutputFile(at:)` method on the publishing context. Like `outputFile(at:)`, this method returns a `File` type, which we can use to get a path to pass on to Tailwind:

```swift
import Files
import Publish
import ShellOut

extension PublishingStep {
    static func generateTailwindCSS(
        inputPath: Path = "Resources/styles.css",
        outputPath: Path = "styles.css"
    ) -> PublishingStep {
        .step(named: "Generate Tailwind CSS", body: { context in
            try shellOut(
                to: "npx",
                arguments: ["tailwindcss", "-i", context.file(at: inputPath).path, "-o", context.createOutputFile(at: outputPath).path, "--minify"]
            )
        })
    }
}
```

The next error we'll run in to depends on if we're running our build pipeline from within Xcode. If you're running in Xcode, you'll likely see an error in the console stating that `npx` cannot be found. Because we're using Publish to generate our site, we end up running a command line executable to perform that work. That executable inherits the environment of where it's running, which includes any modifications you may have made to your `$PATH` environment variable to locate various executables. Those modifications may not be inherited by Xcode, so when you run from within Xcode, it's likely that `npx` won't be found and the style generation step will fail.

To fix this for when we generate our site from within Xcode, we can see if a path to `npx` has been provided as an environment variable and use that, falling back to just calling `npx` and letting it be resolved based off of the `$PATH` in the current environment. Since we'll be using the `ProcessInfo` type for inspecting the environment, we'll also need to import Foundation to get access to that API:

```swift
import Files
import Foundation
import Publish
import ShellOut

extension PublishingStep {
    static func generateTailwindCSS(
        inputPath: Path = "Resources/styles.css",
        outputPath: Path = "styles.css"
    ) -> PublishingStep {
        .step(named: "Generate Tailwind CSS", body: { context in
            try shellOut(
                to: ProcessInfo.processInfo.environment["NPX_BINARY", default: "npx"],
                arguments: ["tailwindcss", "-i", context.file(at: inputPath).path, "-o", context.createOutputFile(at: outputPath).path, "--minify"]
            )
        })
    }
}
```

We can then set the `NPX_BINARY` environment variable to where `npx` lives from within the "Run" section of Xcode's Scheme Editor:

![Xcode's Scheme Editor, highlighting the environment variables for the Publish project's scheme, which has an NPX_BINARY key-value pair.](/img/articles/using-tailwind-with-publish/environment-variables.png)

If we try to run our publishing step now, we may get one last error, again stemming from if we're running our build pipeline from within Xcode or not. By default, when Xcode runs a built command line tool, it'll set the working directory for that process to the built products directory, which will usually be some folder that lives in the depths of `~/Library/Developer/Xcode/`. This folder contains a slew of build artifacts related to your project, including the executable that generates your site, but does not contain your source code, resources, or other content. When you try to run `npx` from this folder, it can't find an installation of Tailwind to generate the styles. There's a couple of ways we could resolve this problem.

First, we could fix this from within Xcode by opening the Scheme Editor again and specifying an explicit working directory in the "Options" tab:

![Xcode Scheme Editor, showing the "Options" tab where the "Working Directory" option lives, allowing us to customize where the executable runs.](/img/articles/using-tailwind-with-publish/working-directory.png)

Alternatively, we could fix this by being explicit about in which directory we run `npx`. By getting a path to the package's root directory and providing that to our `shellOut` call, we can set the working directory for the invocation of `npx`, so it can find the Tailwind installation:

```swift
import Files
import Foundation
import Publish
import ShellOut

extension PublishingStep {
    static func generateTailwindCSS(
        inputPath: Path = "Resources/styles.css",
        outputPath: Path = "styles.css"
    ) -> PublishingStep {
        .step(named: "Generate Tailwind CSS", body: { context in
            try shellOut(
                to: ProcessInfo.processInfo.environment["NPX_BINARY", default: "npx"],
                arguments: ["tailwindcss", "-i", context.file(at: inputPath).path, "-o", context.createOutputFile(at: outputPath).path, "--minify"],
                at: try context.folder(at: "/").path
            )
        })
    }
}
```

With this last change in place, we're in a state where this publishing step works! With this added to our build pipeline, Tailwind will generate someCSS and put it in Publish's `Output` folder for use in your website. While you can copy the code from this page and pull it into your site, I've gone ahead and bundled it up in its own [Publish plugin](https://github.com/grantjbutler/TailwindPublishPlugin). If you have a need to generate your site's syles with Tailwind, check it out and let me know how it works for you!
