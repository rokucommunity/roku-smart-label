function init()
  m.contentGroup = m.top.findNode("contentGroup")
  m.measureLabel = createObject("roSGNode", "Label")

  m.fontFields = ["font", "header3Font", "header2Font", "header1Font", "italicFont", "boldFont"]
  m.settingsKeys = {
    "fontSettings": true
    "header1FontSettings": true
    "header2FontSettings": true
    "header3FontSettings": true
    "italicFontSettings": true
    "boldFontSettings": true
  }

  m.defaultFont = getFont("MediumSystemFont", 20)
  createRegexes()
  setFontDefaults()
  for each settingsKey in m.settingsKeys
    if m.settingsKeys[settingsKey] = true
      m.top.observeField(settingsKey, "updateFonts")
    end if
  end for

  updateFonts()
  m.top.observeField("text", "onTextChange")
  m.top.observeField("allFontSettings", "onAllFontSettingsChange")
  m.top.observeField("values", "onTextChange")
end function

function createRegexes()
  m.regexes = [
    { name: "poster": r: createObject("roRegex", "^\[\[([\s\S]*?\S)\]\]", "") }
    { name: "header3Font": r: createObject("roRegex", "^###([\s\S]*?\S)###", "") }
    { name: "header2Font": r: createObject("roRegex", "^##([\s\S]*?\S)##", "") }
    { name: "header1Font": r: createObject("roRegex", "^#([\s\S]*?\S)#", "") }
    { name: "boldFont": r: createObject("roRegex", "^\*([\s\S]*?\S)\*", "") }
    { name: "italicFont": r: createObject("roRegex", "^_([\s\S]*?\S)_", "") }
    { name: "font": r: createObject("roRegex", "(^[^_*#\[\]]*)", "") }
  ]
end function

function onTextChange()
  resetView()
  text = processTextValues()
  lines = text.split("\n")

  groups = []
  for each line in lines
    groups.push(addLine(line))
  end for

  m.contentGroup.appendChildren(groups)
end function

function processTextValues()
  text = m.top.text
  if m.top.values = invalid
    values = {}
  else 
    values = m.top.values
  end if
  for each key in values
    if (type(values[key]) = "roSGNode")
      m.posters[key] = values[key]
      text = text.replace("${" + key + "}", "[[" + key + "]]")
    else
      text = text.replace("${" + key + "}", values[key])
    end if
  end for

  return text
end function

function addLine(text)
  group = createObject("roSGNode", "LayoutGroup")
  group.layoutDirection = "horiz"
  group.horizAlignment = m.top.horizAlignment
  group.vertAlignment = m.top.vertAlignment
  parts = getLineParts(text)
  'split words
  labels = []
  for each part in parts
    if (part.style = "poster")
      poster = m.posters[part.text]
      if poster <> invalid
        newPoster = m.top.createChild("Poster")
        newPoster.width = poster.width
        newPoster.height = poster.height
        newPoster.uri = poster.uri
        labels.push(newPoster)
      end if
    else
      ? "got part "; part.style ; " text " ; part.text
      label = createLabel(part.text, part.style)
      labels.push(label)
    end if
  end for
  group.appendChildren(labels)
  return group
end function


function getLineParts(text)
  parts = []

  isMore = true
  while isMore and len(text) > 0
    didMatch = false
    for each style in m.regexes
      matches = style.r.match(text)
      if matches.count() = 2 and len(matches[0]) > 0
        parts.push({ text: matches[1], style: style.name })
        text = right(text, len(text) - len(matches[0]))
        didMatch = true
        exit for
      end if
    end for
    if not didMatch
      exit while
    end if
  end while
  if len(text) > 0
    parts.push({ text: text, style: "font" })
  end if
  if parts.count() = 0
    parts.push({ text: " ", style: "font" })
  end if
  return parts
end function

function createLabel(text, name)
  label = createObject("roSGNode", "Label")
  label.font = m[name]
  label.color = m[name + "Color"]
  label.text = text
  return label
end function

function resetView()
  m.posters = {}
  m.contentGroup.removeChildren(m.contentGroup.getChildren(-1, 0))
end function

'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
'++ fonts
'+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

function updateFonts(event = invalid)
  if event = invalid
    fontNames = m.fontFields
  else
    field = event.getField()
    fontNames = [field.replace("Settings", "")]
  end if

  for each fontName in fontNames
    fontSettings = m.top[fontName + "Settings"]
    m[fontName] = getFont(fontSettings.name, fontSettings.size)
    m[fontName + "Color"] = fontSettings.color
  end for

  onTextChange()
end function

function getFont(name, size)
  font = invalid

  m.measureLabel.font = name
  if m.measureLabel.font <> invalid
    m.measureLabel.font.size = size
    return m.measureLabel.font
  end if
  return m.defaultFont
end function

function setFontDefaults()
  m.top.fontSettings = makeFontSetting("font:MediumSystemFont", 20)
  m.top.header1FontSettings = makeFontSetting("font:MediumBoldSystemFont", 40)
  m.top.header2FontSettings = makeFontSetting("font:MediumSystemFont", 30)
  m.top.header3FontSettings = makeFontSetting("font:MediumSystemFont", 30)
  m.top.italicFontSettings = makeFontSetting("font:MediumBoldSystemFont", 18)
  m.top.boldFontSettings = makeFontSetting("font:MediumBoldSystemFont", 22)
end function

function makeFontSetting(name, size, color = "#000000") 
  return {
    name: name
    size: size
    color: color
  }
end function

function updateFontSetting(settingsKey, name, size, color = "#000000")
  fontName = settingsKey.replace("Settings", "")
  if m.settingsKey[settingsKey] <> invalid
    m[fontName] = getFont(name, size)
    m[fontName + "Color"] = color
  else
    ? "unknown settingsKey "; settingsKey
  end if
end function

function onAllFontSettingsChange(event as Object)
  allFontSettings = event.getData()
  for each fontName in allFontSettings
    fontSettings = allFontSettings[fontName]
    if type(fontSettings) = "roAssociativeArray"
      if m.settingsKeys[fontName + "Settings"] <> invalid
        m[fontName] = getFont(fontSettings.name, fontSettings.size)
        m[fontName + "Color"] = fontSettings.color
      else
        ? "unknown fontName " ;fontName
      end if
    else
      ? "illegal font settings for fontName "; fontName
    end if
  end for
  onTextChange()
end function