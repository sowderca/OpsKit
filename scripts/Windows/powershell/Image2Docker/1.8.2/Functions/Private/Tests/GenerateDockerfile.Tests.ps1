﻿Describe 'GenerateDockerfile Tests' {

   Context 'Parameters for GenerateDockerfile'{

        It 'Has a Parameter called ArtifactPath' {
            $Function.Parameters.Keys.Contains('ArtifactPath') | Should Be 'True'
            }
        It 'ArtifactPath Parameter is Identified as Mandatory being True' {
            [String]$Function.Parameters.ArtifactPath.Attributes.Mandatory | Should be 'True'
            }
        It 'ArtifactPath Parameter is of String Type' {
            $Function.Parameters.ArtifactPath.ParameterType.FullName | Should be 'System.String'
            }
        It 'ArtifactPath Parameter is member of ParameterSets' {
            [String]$Function.Parameters.ArtifactPath.ParameterSets.Keys | Should Be '__AllParameterSets'
            }
        It 'ArtifactPath Parameter Position is defined correctly' {
            [String]$Function.Parameters.ArtifactPath.Attributes.Position | Should be '0'
            }
        It 'Does ArtifactPath Parameter Accept Pipeline Input?' {
            [String]$Function.Parameters.ArtifactPath.Attributes.ValueFromPipeline | Should be 'False'
            }
        It 'Does ArtifactPath Parameter Accept Pipeline Input by PropertyName?' {
            [String]$Function.Parameters.ArtifactPath.Attributes.ValueFromPipelineByPropertyName | Should be 'False'
            }
        It 'Does ArtifactPath Parameter use advanced parameter Validation? ' {
            $Function.Parameters.ArtifactPath.Attributes.TypeID.Name -contains 'ValidateNotNullOrEmptyAttribute' | Should Be 'False'
            $Function.Parameters.ArtifactPath.Attributes.TypeID.Name -contains 'ValidateNotNullAttribute' | Should Be 'False'
            $Function.Parameters.ArtifactPath.Attributes.TypeID.Name -contains 'ValidateScript' | Should Be 'False'
            $Function.Parameters.ArtifactPath.Attributes.TypeID.Name -contains 'ValidateRangeAttribute' | Should Be 'False'
            $Function.Parameters.ArtifactPath.Attributes.TypeID.Name -contains 'ValidatePatternAttribute' | Should Be 'False'
            }
        It 'Has Parameter Help Text for ArtifactPath '{
            $function.Definition.Contains('.PARAMETER ArtifactPath') | Should Be 'True'
            }
        It 'Has a Parameter called Artifact' {
            $Function.Parameters.Keys.Contains('Artifact') | Should Be 'True'
            }
        It 'Artifact Parameter is Identified as Mandatory being False' {
            [String]$Function.Parameters.Artifact.Attributes.Mandatory | Should be 'False'
            }
        It 'Artifact Parameter is of String[] Type' {
            $Function.Parameters.Artifact.ParameterType.FullName | Should be 'System.String[]'
            }
        It 'Artifact Parameter is member of ParameterSets' {
            [String]$Function.Parameters.Artifact.ParameterSets.Keys | Should Be '__AllParameterSets'
            }
        It 'Artifact Parameter Position is defined correctly' {
            [String]$Function.Parameters.Artifact.Attributes.Position | Should be '1'
            }
        It 'Does Artifact Parameter Accept Pipeline Input?' {
            [String]$Function.Parameters.Artifact.Attributes.ValueFromPipeline | Should be 'False'
            }
        It 'Does Artifact Parameter Accept Pipeline Input by PropertyName?' {
            [String]$Function.Parameters.Artifact.Attributes.ValueFromPipelineByPropertyName | Should be 'False'
            }
        It 'Does Artifact Parameter use advanced parameter Validation? ' {
            $Function.Parameters.Artifact.Attributes.TypeID.Name -contains 'ValidateNotNullOrEmptyAttribute' | Should Be 'False'
            $Function.Parameters.Artifact.Attributes.TypeID.Name -contains 'ValidateNotNullAttribute' | Should Be 'False'
            $Function.Parameters.Artifact.Attributes.TypeID.Name -contains 'ValidateScript' | Should Be 'False'
            $Function.Parameters.Artifact.Attributes.TypeID.Name -contains 'ValidateRangeAttribute' | Should Be 'False'
            $Function.Parameters.Artifact.Attributes.TypeID.Name -contains 'ValidatePatternAttribute' | Should Be 'False'
            }
        It 'Has Parameter Help Text for Artifact '{
            $function.Definition.Contains('.PARAMETER Artifact') | Should Be 'True'
            }
        It 'Has a Parameter called ArtifactParam' {
            $Function.Parameters.Keys.Contains('ArtifactParam') | Should Be 'True'
            }
        It 'ArtifactParam Parameter is Identified as Mandatory being False' {
            [String]$Function.Parameters.ArtifactParam.Attributes.Mandatory | Should be 'False'
            }
        It 'ArtifactParam Parameter is of String[] Type' {
            $Function.Parameters.ArtifactParam.ParameterType.FullName | Should be 'System.String[]'
            }
        It 'ArtifactParam Parameter is member of ParameterSets' {
            [String]$Function.Parameters.ArtifactParam.ParameterSets.Keys | Should Be '__AllParameterSets'
            }
        It 'ArtifactParam Parameter Position is defined correctly' {
            [String]$Function.Parameters.ArtifactParam.Attributes.Position | Should be '2'
            }
        It 'Does ArtifactParam Parameter Accept Pipeline Input?' {
            [String]$Function.Parameters.ArtifactParam.Attributes.ValueFromPipeline | Should be 'False'
            }
        It 'Does ArtifactParam Parameter Accept Pipeline Input by PropertyName?' {
            [String]$Function.Parameters.ArtifactParam.Attributes.ValueFromPipelineByPropertyName | Should be 'False'
            }
        It 'Does ArtifactParam Parameter use advanced parameter Validation? ' {
            $Function.Parameters.ArtifactParam.Attributes.TypeID.Name -contains 'ValidateNotNullOrEmptyAttribute' | Should Be 'False'
            $Function.Parameters.ArtifactParam.Attributes.TypeID.Name -contains 'ValidateNotNullAttribute' | Should Be 'False'
            $Function.Parameters.ArtifactParam.Attributes.TypeID.Name -contains 'ValidateScript' | Should Be 'False'
            $Function.Parameters.ArtifactParam.Attributes.TypeID.Name -contains 'ValidateRangeAttribute' | Should Be 'False'
            $Function.Parameters.ArtifactParam.Attributes.TypeID.Name -contains 'ValidatePatternAttribute' | Should Be 'False'
            }
        It 'Has Parameter Help Text for ArtifactParam '{
            $function.Definition.Contains('.PARAMETER ArtifactParam') | Should Be 'True'
            }
    }
    Context "Function $($function.Name) - Help Section" {

            It "Function $($function.Name) Has show-help comment block" {

                $function.Definition.Contains('<#') | should be 'True'
                $function.Definition.Contains('#>') | should be 'True'
            }

            It "Function $($function.Name) Has show-help comment block has a.SYNOPSIS" {

                $function.Definition.Contains('.SYNOPSIS') -or $function.Definition.Contains('.Synopsis') | should be 'True'

            }

            It "Function $($function.Name) Is an advanced function" {

                $function.CmdletBinding | should be 'True'
                $function.Definition.Contains('param') -or  $function.Definition.Contains('Param') | should be 'True'
            }
    
    }

 }


