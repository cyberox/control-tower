package commands

import (
	"errors"
	"fmt"
	"os"

	"bitbucket.org/engineerbetter/concourse-up/bosh"
	"bitbucket.org/engineerbetter/concourse-up/concourse"
	"bitbucket.org/engineerbetter/concourse-up/config"
	"bitbucket.org/engineerbetter/concourse-up/terraform"
	"bitbucket.org/engineerbetter/concourse-up/util"

	"gopkg.in/urfave/cli.v1"
)

var destroy = cli.Command{
	Name:      "destroy",
	Aliases:   []string{"x"},
	Usage:     "Destroys a Concourse",
	ArgsUsage: "<name>",
	Action: func(c *cli.Context) error {
		name := c.Args().Get(0)
		if name == "" {
			return errors.New("Usage is `concourse-up destroy <name>`")
		}

		if !NonInteractiveModeEnabled() {
			confirm, err := util.CheckConfirmation(os.Stdin, os.Stdout, name)
			if err != nil {
				return err
			}

			if !confirm {
				fmt.Println("Bailing out...")
				return nil
			}
		}

		return concourse.Destroy(name, terraform.NewClient, bosh.NewBoshInitClient, &config.Client{}, os.Stdout, os.Stderr)
	},
}