# ChangeLog
## Version 4.1.0

Introduced a new validation option called `environmentTooDark` that can be set as part of the `Configuration` object. This new validation option is activated by default, meaning that the SDK will require a bright environment to return a valid frame containing a face. In order to migrate from previous versions, it is needed to include any required validation option except the `environmentTooDark` option when creating the `Configuration` object.
If the environment where the face is being captured is not meeting the brightness threshold value, the SDK will return a new error called `environmentTooDark`.
Please, check [README.md](https://github.com/getyoti/yoti-face-capture-ios/blob/main/README.md) for more details.
