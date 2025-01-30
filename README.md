# nautical-chart-symbols
Here are a set of simple samples that show you how to symbolize S-57 data with an INT1 chart-like view. Learn more [here](https://enterprise.arcgis.com/en/maritime/).

Examples can be found at [Esri Hydrographic Office](https://esriho.maps.arcgis.com/home/index.html).

## Features
Lua in Maritime Chart Service can do the following:
* Reference SVG files to override point symbols or line patterns (simple and complex)
* Override symbol instructions such as color, fill pattern, or transparency
* Access view groups or display properties
* Provide instructions to modify a text group's font name, size, weight, color, and offset

## Instructions
The ServerConfiguration.xml file contains a CustomSymbology boolean to enable or disable display of custom symbology that overrides the default S-52 presentation library. When available, Maritime Chart Service references rules in the CustomSymbolMap.xml, Scalable Vector Graphic (SVG) symbols, and Lua scripts to provide a paper chart-like display of the S-57 data..
1. Fork and then clone the repo.
2. Configure your ArcGIS Maritime Chart Service. See online help.
3. Follow directions to enable Custom Symbology. See online help.
4. After setting custom symbology to true, you must rebuild the .senc files for the symbols to appear in your service.

## Requirements

* ArcGIS Server for Windows
* ArcGIS Maritime Chart Service extension 11.4 or newer.
* Web browser with access to the Internet

## Resources

* [ArcGIS Maritime server web help](https://enterprise.arcgis.com/en/maritime/)
* [Esri Hydrographic Office](https://esriho.maps.arcgis.com/home/index.html)
* [ArcGIS Maritime Community](https://community.esri.com/t5/arcgis-maritime/ct-p/arcgis-maritime)
* [Maritime email](maritime@esri.com)
* [twitter@esri](http://twitter.com/esri)

## Issues

Find a bug or want to request a new feature?  Please let us know by submitting an issue.

## Contributing

Esri welcomes contributions from anyone and everyone. Please see our [guidelines for contributing](https://github.com/esri/contributing).

## Licensing
Copyright 2023 Esri

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

   http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

A copy of the license is available in the repository's [license.txt](https://github.com/ArcGIS/nautical-chart-symbols/blob/main/license.txt)
