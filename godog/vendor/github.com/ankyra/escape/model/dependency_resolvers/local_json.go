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

package dependency_resolvers

import (
	"encoding/json"
	"fmt"
	core "github.com/ankyra/escape-core"
	"github.com/ankyra/escape/model/paths"
	"github.com/ankyra/escape/util"
	"io/ioutil"
)

func FromLocalReleaseJson(path *paths.Path, dep *core.Dependency) (bool, error) {
	releaseJson := path.UnpackedDepDirectoryReleaseMetadata(dep)
	if util.PathExists(releaseJson) {
		contents, err := ioutil.ReadFile(releaseJson)
		if err != nil {
			return false, fmt.Errorf("Couldn't read dependency release.json: %s", err.Error())
		}
		escapePlan := map[string]interface{}{}
		err = json.Unmarshal(contents, &escapePlan)
		if err != nil {
			return false, fmt.Errorf("Couldn't unmarshal dependency release.json: %s", err.Error())
		}
		version, ok := escapePlan["version"]
		if !ok {
			util.RemoveTree(path.UnpackedDepDirectory(dep))
			return false, nil
		}
		if version.(string) != dep.Version {
			util.RemoveTree(path.UnpackedDepDirectory(dep))
			return false, nil
		}
		return true, nil
	}
	return false, nil
}
