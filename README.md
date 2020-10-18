# Roku Smart Label

BBEdit style label, allowing to mix different fonts and images. Reference implementation, looking for contributors

![build](https://github.com/rokucommunity/roku-smart-label/workflows/build/badge.svg)
[![NPM Version](https://badge.fury.io/js/roku-smart-label.svg?style=flat)](https://npmjs.org/package/roku-smart-label)

## Installation
### Using ropm
```bash
ropm install roku-smart-label
```

suggestion: use a shorter prefix:

```bash
ropm install sl@roku-smart-label
```

## Usage

### Declare a label component

#### In XML

*without prefix:*

```
  <rokusmartlabel_Smart_Label 
      id="label"
      width='900' />
```


*using sl prefix:*

```
  <sl_Smart_Label 
      id="label"
      width='900' />
```

#### In Brighterscript

*without prefix:*

```
  label = createOject("roSGNode
  "rokusmartlabel_Smart_Label")
  label.width = 900
```


*using sl prefix:*

```
  label = createOject("roSGNode", "sl_Smart_Label")
  label.width = 900
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
