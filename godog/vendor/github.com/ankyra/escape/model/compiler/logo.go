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

package compiler

import (
	"encoding/base64"
	"fmt"
	"github.com/ankyra/escape/util"
	"io/ioutil"
)

func compileLogo(ctx *CompilerContext) error {
	logo := ctx.Plan.Logo
	if logo == "" {
		return nil
	}
	if !util.PathExists(logo) {
		return fmt.Errorf("Referenced logo '%s' does not exist", logo)
	}
	data, err := ioutil.ReadFile(logo)
	if err != nil {
		return fmt.Errorf("Couldn't read logo '%s': %s", logo, err.Error())
	}
	ctx.Metadata.Logo = base64.StdEncoding.EncodeToString(data)
	return nil
}
