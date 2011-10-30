headerColor = "#515151"
linkColor = '#00B7FF'

h1 = ->
  'font-size': '28px'
  'line-height': '108%'
  'letter-spacing': '0.15em'
  'font-family': '"Courier New", monospace'
  'font-variant': 'small-caps'
  'text-shadow': '2px 1px 3px #2f4f4f'
h2 = ->
  color: '#515151'
  font: 'bold 26px/28px "Trebuchet MS",Georgia,Arial,Helvetica'
  'letter-spacing': '-1px'
  'text-shadow': '3px 2px 3px #b8b8b8'
  margin: '0'
h3 = ->
  color: '#666'
  font: 'normal 20px/20px "Trebuchet MS",Georgia,Arial,Helvetica'
  'letter-spacing': '-1px'
  'text-shadow': '0 0 2px #D2D2D2'
  padding: '0.4em 0.2em 0.4em 0.24em'
p = ->
  'font-family': 'Droid Serif, serif'
  'font-size': '1.125em'
  'line-height': '1.45em'
  'text-align': 'justify'

module.exports =
  html:
    height: "100%"

  "body:before":
    content: "''"
    position: "fixed"
    top: '-10px'
    left: '0'
    width: '100%'
    height: '10px'
    'box-shadow': '0 0 10px rgba(0,0,0,.8)'
    'z-index': '100'
  body:
    height: '100%'
    'background-color': 'rgb(245, 245, 245)'
    color: '#222'
    padding: '50px'
    padding: '0'

  "#container":
    height: '100%'
    margin: '0 auto'
    'max-width': '72em'
    'min-width': '32em'

  header:
    padding: '40px 0 15px 0'
    margin: '0 25px 0 25px'
    'box-shadow': '0 4px 2px -2px gray'
    h2:
      'text-align': 'center'
      'padding-bottom': '0.25em'

  "body h1": do h1
  h1:
    a:
      color: headerColor
      border: "0"
    "a:visited":
      color: headerColor
      border: "0"

  "body h2": do h2
  h2:
    a:
      color: headerColor
      border: "0"
    "a:visited":
      color: headerColor
      border: "0"

  "body h3": do h3
  h3:
    a:
      color: headerColor
      border: "0"
    "a:visited":
      color: headerColor
      border: "0"

  h4:
    color: '#515151'
    margin: '0'
    padding: '0.2em 0 0.1em 0'

  "body p": do p
  p:
    a:
      color: linkColor

  ".post":
    'background-color': 'white'
    'box-shadow': '3px 0px 2px #888, -3px 0px 2px #888'
    padding: '12px'
    margin: '15px'

    "p:first-letter":
      'font-size': '1.8em'
    'p + p':
      'text-indent': '2.5em'
    'p + p:first-letter':
      'font-size': '1em'
    '.content':
      margin: '10px 10px 10px 10px'
    textarea:
      width: '100%'
      margin: '3px 0 7px 0'
      padding: '0'
    hgroup:
      padding: '4px 2px 4px 2px'
      "h2":
        'margin-top': '5px'
        'padding-top': '0.125em'
        display: 'inline-block'
      'h4':
        float: 'right'
        display: 'inline-block'
        'margin-right': '-3px'
    '.content':
      clear: 'both'
    "#title input": do h2
    label: do h3

  "#new-post":
    "#title":
      'line-height': '.75em'
      'padding-bottom': '7px'
      input:
        width: '100%'
        padding: '0'
    "#body":
      'line-height': '.75em'
      'padding-bottom': '7px'
    textarea: do p

  ".button":
    input:
      border: 'solid 1px rgb(133, 177, 222)'
      'background-color': 'rgba(237, 242, 247, 0.55)'
      display: 'block'
      margin: '2px auto 2px auto'
      padding: '4px'

  # To remove the scrollbar.
  ".syntaxhighlighter":
    padding: '1px !important'
