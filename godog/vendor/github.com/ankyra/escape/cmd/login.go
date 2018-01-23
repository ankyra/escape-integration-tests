/*
Copyright 2017, 2018 Ankyra

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package cmd

import (
	"github.com/ankyra/escape/controllers"
	"github.com/spf13/cobra"
)

var username, password, url, authMethod, targetProfile string
var insecureSkipVerify bool

var loginCmd = &cobra.Command{
	Use:     "login",
	Short:   "Authenticate with an Escape server",
	PreRunE: NoExtraArgsPreRunE,
	RunE: func(cmd *cobra.Command, args []string) error {
		if url == "" {
			cmd.UsageFunc()(cmd)
			return nil
		}
		return controllers.LoginController{}.Login(context, url, authMethod, username, password, insecureSkipVerify, targetProfile)
	},
}

func init() {
	RootCmd.AddCommand(loginCmd)
	loginCmd.Flags().StringVarP(&username, "username", "u", "", "The username")
	loginCmd.Flags().StringVarP(&password, "password", "p", "", "The password")
	loginCmd.Flags().StringVarP(&url, "url", "e", "", "The Escape server URL")
	loginCmd.Flags().BoolVarP(&insecureSkipVerify, "insecure-skip-verify", "i", false,
		"Don't verify server's certificate chain and host name.")
	loginCmd.Flags().StringVarP(&authMethod, "auth-method", "", "", "If available, use this auth method instead of prompting for user input")
	loginCmd.Flags().StringVarP(&targetProfile, "target-profile", "", "", "The name of the new profile to create when logging in")
}
