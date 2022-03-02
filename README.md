# Roku Smart Label

BBEdit style label, allowing to mix different fonts and images. Reference implementation, looking for contributors

[![build status](https://img.shields.io/github/workflow/status/rokucommunity/roku-smart-label/build.svg?logo=github)](https://github.com/rokucommunity/roku-smart-label/actions?query=workflow%3Abuild)
[![monthly downloads](https://img.shields.io/npm/dm/roku-smart-label.svg?sanitize=true&logo=npm&logoColor=)](https://npmcharts.com/compare/roku-smart-label?minimal=true)
[![npm version](https://img.shields.io/npm/v/roku-smart-label.svg?logo=npm)](https://www.npmjs.com/package/roku-smart-label)
[![license](https://img.shields.io/github/license/rokucommunity/roku-smart-label.svg)](LICENSE)
[![Slack](https://img.shields.io/badge/Slack-RokuCommunity-4A154B?logo=slack)](https://join.slack.com/t/rokudevelopers/shared_invite/zt-4vw7rg6v-NH46oY7hTktpRIBM_zGvwA)

## Installation

### Using ropm

Use the [ropm package manager for roku](https://github.com/rokucommunity/ropm)

```bash
ropm install roku-smart-label
```

suggestion: use a shorter prefix:

```bash
ropm install sl@npm:roku-smart-label
```

## Usage

Follow these steps:

  1. Declare a label component
  1. Set font settings
  1. Assign values
  1. Assign text

Note that updating any property causes a _brute force reload_ of all the data

### Declare a label component

#### In XML

*without prefix:*

```
  <rokusmartlabel_SmartLabel
      id="label"
      width='900' />
```


*using sl prefix:*

```
  <sl_SmartLabel
      id="label"
      width='900' />
```

#### In Brighterscript

*without prefix:*

```
  label = createObject("roSGNode", "rokusmartlabel_SmartLabel")
  label.width = 900
```


*using sl prefix:*

```
  label = createObject("roSGNode", "sl_SmartLabel")
  label.width = 900
```

### Assign font styles

The following styles are supported

| style name | format |
| --- | --- |
| default | text |
| italic | _text_ |
| bold | *text* |
| header1 | #text# |
| header2 | ##text## |
| header3 | ###text### |

#### Setting individual styles

Assign font styles by setting label. _style_ FontSettings (e.g. `label.boldFontSettings`), to an aa like:

```
{
      name: "font:MediumBoldSystemFont"
      size: 130
      color: "#ffffff"
    }
```

#### Setting all font styles

Set `m.allFontSettings` to an assocarray, with the styles you wish to set

```
  m.label.allFontSettings = {
    header1Font: {
      name: "font:MediumBoldSystemFont"
      size: 130
    }
    header2Font: {
      name: "font:MediumBoldSystemFont"
      size: 60
    }
    header3Font: {
      name: "font:MediumSystemFont"
      size: 50
    }
    font: {
      name: "font:MediumSystemFont"
      size: 30
    }
    italicFont: {
      name: "font:MediumBoldSystemFont"
      size: 32
    }
    boldFont: {
      name: "font:MediumSystemFont"
      size: 34
  } }
```

### Assign values

Label supports template substitution, of values in the form `text ${KEY} more text`. To drive the template system, simply set the `label.values` to an assocarray, as follows:
```
{
  aKey: "value1"
  anotherKey: "value2"
}
```

#### Inline images

You can also include posters in your label. Provide an instance of a poster, configured how you wish it to appear in your values:
```
poster = createObject("roSGnode", "Poster")
poster.width =40
poster.height = 40
poster.uri= "http:/example.com/image.png"

{
  aKey: "value1"
  anotherKey: poster
}
```

### Assign text

```
  ' create and configure your label
  ' set values
  ' then set text
  text = "\n#TITLE1:#"
  text += "\n##TITLE2:##"
  text += "\n###TITLE3:###"
  text += "\n*bold text here*"
  text += "\n_italic text here_"
  text += "\nregular text"
  text += "\nposter 1 ${so1} poster 2 ${so2} poster 3 ${so3}"

  m.label.text = text
```