## Generate-ModAdvancementOverrideFiles.ps1
> Written for Minecraft 1.20.1

This PowerShell script is used to generate advancement override files for Minecraft mods with the same configuration from a template file. It scans through all the mod jar files in a specified directory, identifies advancement files that are not in a /recipies or /loot_tables subfolder, and generates corresponding override files in a specified DataPack folder.

The primary purpose of this, and the sample null-advancement-template.json file, is to effectivly disable ALL advancementes that are added by Mods.

This will only apply to vanilla advancements if a mod is installed that was overriding them.

### Parameters

- `ModFolderPath` (String): The root folder where all the mod jar files are located.
- `DataPackFolderPath` (String): The root folder of the DataPack where all the advancement overrides will be generated.
- `AdvancementTemplateFilePath` (String): The path to the JSON file that will be used as a template for the advancement overrides.
- `OverWriteExistingFiles` (Switch): If set, will overwrite existing files instead of just adding missing ones.
- `CreateLogFile` (Switch): If set, will generate a timestamped log file in the same directory as the script of all files modified or created


### Usage

``` PowerShell
.\Generate-ModAdvancementOverrideFiles.ps1 -ModFolderPath "path\to\mods" -DataPackFolderPath "path\to\datapack" -AdvancementTemplateFilePath "path\to\template.json" [-OverWriteExistingFiles]
```

### Example

``` PowerShell
.\Generate-ModAdvancementOverrideFiles.ps1 -ModFolderPath "C:\Minecraft\Mods" -DataPackFolderPath "C:\Minecraft\DataPacks" -AdvancementTemplateFilePath "C:\Minecraft\Templates\advancement_template.json" -OverWriteExistingFiles
```

This example will scan all the jar files in C:\Minecraft\Mods, find all the advancement files, and generate override files in C:\Minecraft\DataPacks using the template located at C:\Minecraft\Templates\advancement_template.json. Existing files will be overwritten.

### Shoutouts

The Advancement Template included with this script is from the [SkyFactory 5 modpack](https://www.curseforge.com/minecraft/modpacks/skyfactory-5)