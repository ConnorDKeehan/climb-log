# climasys

Climasys

## Good shit to know for this project

Folder structure should always be:
Features
    -page_name (folder)
        -page_name.dart (this should never take parameters, anything needed from state should be taken from context)
        -page_name_button.dart (if a custom button exists to navigate to the page put this in the same dir)
        -functions (this is for helper functions that will need to be used in multiple files for this feature)
        -models
        -widgets (child widgets of the feature page)
            -widget (folder)
                this follows the same structure as the parent page(recursive)
Api
    -apiname (folder)
        apiname_api.dart
        models(folder)