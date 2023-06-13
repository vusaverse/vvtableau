# vvtableau #

The `vvtableau` package is an R interface for interacting with Tableau Server using the Tableau REST API. It provides a convenient way to automate Tableau tasks, such as publishing workbooks, refreshing data extracts, managing users and groups, and retrieving information about server objects directly from R. Additionally, it includes functions to download filtered views, workbooks, and export them to different formats like PDF and PowerPoint.

Furthermore, methods are included to interact with Tableau desktop. These methods allow you to retrieve information from workbooks and to change them.

## Features
- Authenticate and establish a connection to Tableau Server.
- Check the existence of specific dashboard names.
- Download filtered views from Tableau Server.
- Download workbooks from Tableau Server in various formats (PDF, PowerPoint).
- Retrieve information about actions, folders, hierarchies, parameters, revisions, server applications, datasources, groups, locations, projects, refresh tasks, schedules, users, views, and workbooks.
- Retrieve Tableau data source information.
- Manage variables and variable folders.
- Retrieve workbook IDs and tabs.

## Installation

You can install the tableauR package from GitHub using the devtools package:

```{r}
devtools::install_github("vusaverse/vvtableau")
library(vvtableau)
```

## Contributing

Contributions to vvtableau are welcome! If you encounter any bugs, have feature requests, or would like to contribute code improvements, please open an issue or submit a pull request on the GitHub repository.
