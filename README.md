# Apex Mockery Hands-on Project

This project is designed to get your hands dirty with the [apex-mockery](https://github.com/salesforce/apex-mockery) API's

# Project Structure

    .
    ├── account-app             # Customizations On Account
    ├── contact-app             # Customizations On Contact with Apex Mockery
    ├── apex-mockery            # Apex Mockery classes
    └── twilio-client           # Twilio Client Implementation with Apex Mockery

# Deployment

This repository uses [replace strings](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_string_replace.htm) so there's an additional setup required to run on your command line.
If you're in windows; you'll have to convert everyting into mdapi then deploy

1. `export SF_APPLY_REPLACEMENTS_ON_CONVERT=true`
2. `export TWILIO_URL='your-twilio-url'`
3. `sf project convert source --output-dir mdapiOut --source-dir account-app`
4. `sf project convert source --output-dir mdapiOut --source-dir contact-app`
5. `sf project convert source --output-dir mdapiOut --source-dir apex-mockery`
6. `sf project convert source --output-dir mdapiOut --source-dir twilio-client`
7. `sf project generate manifest --source-dir mdapiOut --output-dir mdapiOut`
8. `sf project deploy start --source-dir mdapiOut --target-org <your-target-org>`

If you're using MacOs, life's easy

1. `echo 'TWILIO_URL='your-twilio-url > .env`
2. `npx dotenv -e .env sf project deploy start --source-dir . --target-org <your-target-org`
