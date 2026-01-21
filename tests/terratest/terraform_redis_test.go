package test

import (
	"fmt"
	"testing"
	"time"

	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestTerraformRedis(t *testing.T) {
	t.Parallel()

	// Generate unique suffix using timestamp
	suffix := fmt.Sprintf("%d", time.Now().Unix())

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../../example",
		VarFiles:     []string{"terratest.tfvars"},
		Upgrade:      true,
		Vars: map[string]interface{}{
			"name_suffix": suffix,
		},
	}

	// Defer the destroy to cleanup all created resources
	defer terraform.Destroy(t, terraformOptions)

	// This will init and apply the resources and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Assert inputs with outputs
	outputs_instance_id := terraform.Output(t, terraformOptions, "redis_cache_instance_id")
	outputs_hostname := terraform.Output(t, terraformOptions, "redis_cache_hostname")
	outputs_ssl_port := terraform.Output(t, terraformOptions, "redis_cache_ssl_port")

	expectedInstanceID := fmt.Sprintf("/subscriptions/8cdb5405-7535-4349-92e9-f52bddc7833a/resourceGroups/rg-lab-cpp-redisterratest/providers/Microsoft.Cache/redis/test-redis-%s", suffix)
	expectedHostname := fmt.Sprintf("test-redis-%s.redis.cache.windows.net", suffix)

	assert.Equal(t, expectedInstanceID, outputs_instance_id)
	assert.Equal(t, expectedHostname, outputs_hostname)
	assert.Equal(t, "6380", outputs_ssl_port)

}
