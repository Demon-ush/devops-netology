Домашнее задание к занятию 
«2.4. Инструменты Git»

1. 1.	Найти полный хеш и комментарий коммита, хеш которого начинается на aefea.

#git log --oneline | grep aefea
aefead220 Update GHANGELOG.md
     
#git show aefea
commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545
Author: Alisdair McDiarmid <alisdair@users.noreply.github.com>
Date: Thu Jun 18 10:29:58 2020 -0400
Update CHANGELOG.md
diff --git a/CHANGELOG.md b/CHANGELOG.md
index 86d70e3e0..588d807b1 100644
--- a/CHANGELOG.md
+++ b/CHANGELOG.md
@@ -27,6 +27,7 @@ BUG FIXES:
* backend/s3: Prefer AWS shared configuration over EC2 metadata credentials by default ([#25134](https://github.com/hashicorp/terraform/issues/25134))
* backend/s3: Prefer ECS credentials over EC2 metadata credentials by default ([#25134](https://github.com/hashicorp/terraform/issues/25134))
* backend/s3: Remove hardcoded AWS Provider messaging ([#25134](https://github.com/hashicorp/terraform/issues/25134))
+* command: Fix bug with global `-v`/`-version`/`--version` flags introduced in 0.13.0beta2 [GH-25277]
* command/0.13upgrade: Fix `0.13upgrade` usage help text to include options ([#25127](https://github.com/hashicorp/terraform/issues/25127))
* command/0.13upgrade: Do not add source for builtin provider ([#25215](https://github.com/hashicorp/terraform/issues/25215))
* command/apply: Fix bug which caused Terraform to silently exit on Windows when using absolute plan path ([#25233](https://github.com/hashicorp/terraform/issues/25233))


2. 2.	Какому тегу соответствует коммит 85024d3?

#git show 85024d3
commit 85024d3100126de36331c6982bfaac02cdab9e76
Author: tf-release-bot <terraform@hashicorp.com>
Date: Thu Mar 5 20:56:10 2020 +0000
v0.12.23
diff --git a/CHANGELOG.md b/CHANGELOG.md
index 1a9dcd0f9..faedc8bf4 100644
--- a/CHANGELOG.md
+++ b/CHANGELOG.md
@@ -1,4 +1,4 @@
-## 0.12.23 (Unreleased)
+## 0.12.23 (March 05, 2020)
## 0.12.22 (March 05, 2020)
ENHANCEMENTS:
diff --git a/version/version.go b/version/version.go
index 33ac86f5d..bcb6394d2 100644
--- a/version/version.go
+++ b/version/version.go
@@ -16,7 +16,7 @@ var Version = "0.12.23"
// A pre-release marker for the version. If this is "" (empty string)
// then it means that it is a final release. Otherwise, this is a pre-release
// such as "dev" (in development), "beta", "rc1", etc.
-var Prerelease = "dev"
+var Prerelease = ""
// SemVer is an instance of version.Version. This has the secondary
// benefit of verifying during tests and init time that our version is a
    
    
3. 3.	Сколько родителей у коммита b8d720? Написать их хеши.

2

git show b8d720
commit b8d720f8340221f2146e4e4870bf2ee0bc48f2d5
Merge: 56cd7859e 9ea88f22f
Author: Chris Griggs <cgriggs@hashicorp.com>
Date: Tue Jan 21 17:45:48 2020 -0800
Merge pull request #23916 from hashicorp/cgriggs01-stable
[Cherrypick] community links
    

4. 4.	Перечислить хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24.

$git log --pretty=oneline v0.12.23...v0.12.24

33ff1c03bb960b332be3af2e333462dde88b279e v0.12.24
b14b74c4939dcab573326f4e3ee2a62e23e12f89 [Website] vmc provider links
3f235065b9347a758efadc92295b540ee0a5e26e Update CHANGELOG.md
6ae64e247b332925b872447e9ce869657281c2bf registry: Fix panic when server is unreachable
5c619ca1baf2e21a155fcdb4c264cc9e24a2a353 website: Remove links to the getting started guide's old location
06275647e2b53d97d4f0a19a0fec11f6d69820b5 Update CHANGELOG.md
d5f9411f5108260320064349b757f55c09bc4b80 command: Fix bug when using terraform login on Windows
4b6d06cc5dcb78af637bbb19c198faff37a066ed Update CHANGELOG.md
dd01a35078f040ca984cdd349f18d0b67e486c35 Update CHANGELOG.md
225466bc3e5f35baa5d07197bbc079345b77525e Cleanup after v0.12.23 release


5. 5.	Найти коммит, в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...) (вместо троеточего перечислены аргументы).

$git log -S "func providerSource" --oneline

5af1e6234 main: Honor explicit provider_installation CLI config when present
8c928e835 main: Consult local directories as potential mirrors of providers

$git show 8c928e835

commit 8c928e83589d90a031f811fae52a81be7153e82f
Author: Martin Atkins <mart@degeneration.co.uk>
Date: Thu Apr 2 18:04:39 2020 -0700
main: Consult local directories as potential mirrors of providers
This restores some of the local search directories we used to include when
searching for provider plugins in Terraform 0.12 and earlier. The
directory structures we are expecting in these are different than before,
so existing directory contents will not be compatible without
restructuring, but we need to retain support for these local directories
so that users can continue to sideload third-party provider plugins until
the explicit, first-class provider mirrors configuration (in CLI config)
is implemented, at which point users will be able to override these to
whatever directories they want.
This also includes some new search directories that are specific to the
operating system where Terraform is running, following the documented
layout conventions of that platform. In particular, this follows the
XDG Base Directory specification on Unix systems, which has been a
somewhat-common request to better support "sideloading" of packages via
standard Linux distribution package managers and other similar mechanisms.
While it isn't strictly necessary to add that now, it seems ideal to do
all of the changes to our search directory layout at once so that our
documentation about this can cleanly distinguish "0.12 and earlier" vs.
"0.13 and later", rather than having to document a complex sequence of
smaller changes.
Because this behavior is a result of the integration of package main with
package command, this behavior is verified using an e2etest rather than
a unit test. That test, TestInitProvidersVendored, is also fixed here to
create a suitable directory structure for the platform where the test is
being run. This fixes TestInitProvidersVendored.

diff --git a/command/e2etest/init_test.go b/command/e2etest/init_test.go
index 9fcddbfb7..3031695a7 100644
--- a/command/e2etest/init_test.go
+++ b/command/e2etest/init_test.go
@@ -100,6 +100,16 @@ func TestInitProvidersVendored(t *testing.T) {
tf := e2e.NewBinary(terraformBin, fixturePath)
defer tf.Close()
+ // Our fixture dir has a generic os_arch dir, which we need to customize
+ // to the actual OS/arch where this test is running in order to get the
+ // desired result.
+ fixtMachineDir := tf.Path("terraform.d/plugins/registry.terraform.io/hashicorp/null/1.0.0+local/os_arch")
+ wantMachineDir := tf.Path("terraform.d/plugins/registry.terraform.io/hashicorp/null/1.0.0+local/", fmt.Sprintf("%s_%s", runtime.GOOS, runtime.GOARCH))
+ err := os.Rename(fixtMachineDir, wantMachineDir)
+ if err != nil {
+ t.Fatalf("unexpected error: %s", err)
+ }
+
stdout, stderr, err := tf.Run("init")
if err != nil {
t.Errorf("unexpected error: %s", err)
diff --git a/main.go b/main.go
index 762d566a5..f9a3b9cf8 100644
--- a/main.go
+++ b/main.go
@@ -17,7 +17,6 @@ import (
"github.com/hashicorp/terraform/command/format"
"github.com/hashicorp/terraform/helper/logging"
"github.com/hashicorp/terraform/httpclient"
- "github.com/hashicorp/terraform/internal/getproviders"
"github.com/hashicorp/terraform/version"
"github.com/mattn/go-colorable"
"github.com/mattn/go-shellwords"
@@ -169,7 +168,7 @@ func wrappedMain() int {
// direct from a registry. In future there should be a mechanism to
// configure providers sources from the CLI config, which will then
// change how we construct this object.
- providerSrc := getproviders.NewRegistrySource(services)
+ providerSrc := providerSource(services)

// Initialize the backends.
backendInit.Init(services)
diff --git a/provider_source.go b/provider_source.go
new file mode 100644
index 000000000..9524e0985
--- /dev/null
+++ b/provider_source.go
@@ -0,0 +1,89 @@
+package main
+
+import (
+ "log"
+ "os"
+ "path/filepath"
+
+ "github.com/apparentlymart/go-userdirs/userdirs"
+
+ "github.com/hashicorp/terraform-svchost/disco"
+ "github.com/hashicorp/terraform/command/cliconfig"
+ "github.com/hashicorp/terraform/internal/getproviders"
+)
+
+// providerSource constructs a provider source based on a combination of the
+// CLI configuration and some default search locations. This will be the
+// provider source used for provider installation in the "terraform init"
+// command, unless overridden by the special -plugin-dir option.
+func providerSource(services *disco.Disco) getproviders.Source {
+ // We're not yet using the CLI config here because we've not implemented
+ // yet the new configuration constructs to customize provider search
+ // locations. That'll come later.
+ // For now, we have a fixed set of search directories:
+ // - The "terraform.d/plugins" directory in the current working directory,
+ // which we've historically documented as a place to put plugins as a
+ // way to include them in bundles uploaded to Terraform Cloud, where
+ // there has historically otherwise been no way to use custom providers.
+ // - The "plugins" subdirectory of the CLI config search directory.
+ // (thats ~/.terraform.d/plugins on Unix systems, equivalents elsewhere)
+ // - The "plugins" subdirectory of any platform-specific search paths,
+ // following e.g. the XDG base directory specification on Unix systems,
+ // Apple's guidelines on OS X, and "known folders" on Windows.
+ //
+ // Those directories are checked in addition to the direct upstream
+ // registry specified in the provider's address.
+ var searchRules []getproviders.MultiSourceSelector
+
+ addLocalDir := func(dir string) {
+ // We'll make sure the directory actually exists before we add it,
+ // because otherwise installation would always fail trying to look
+ // in non-existent directories. (This is done here rather than in
+ // the source itself because explicitly-selected directories via the
+ // CLI config, once we have them, _should_ produce an error if they
+ // don't exist to help users get their configurations right.)
+ if info, err := os.Stat(dir); err == nil && info.IsDir() {
+ log.Printf("[DEBUG] will search for provider plugins in %s", dir)
+ searchRules = append(searchRules, getproviders.MultiSourceSelector{
+ Source: getproviders.NewFilesystemMirrorSource(dir),
+ })
+ } else {
+ log.Printf("[DEBUG] ignoring non-existing provider search directory %s", dir)
+ }
+ }
+
+ addLocalDir("terraform.d/plugins") // our "vendor" directory
+ cliConfigDir, err := cliconfig.ConfigDir()
+ if err != nil {
+ addLocalDir(filepath.Join(cliConfigDir, "plugins"))
+ }
+
+ // This "userdirs" library implements an appropriate user-specific and
+ // app-specific directory layout for the current platform, such as XDG Base
+ // Directory on Unix, using the following name strings to construct a
+ // suitable application-specific subdirectory name following the
+ // conventions for each platform:
+ //
+ // XDG (Unix): lowercase of the first string, "terraform"
+ // Windows: two-level heirarchy of first two strings, "HashiCorp\Terraform"
+ // OS X: reverse-DNS unique identifier, "io.terraform".
+ sysSpecificDirs := userdirs.ForApp("Terraform", "HashiCorp", "io.terraform")
+ for _, dir := range sysSpecificDirs.DataSearchPaths("plugins") {
+ addLocalDir(dir)
+ }
+
+ // Last but not least, the main registry source! We'll wrap a caching
+ // layer around this one to help optimize the several network requests
+ // we'll end up making to it while treating it as one of several sources
+ // in a MultiSource (as recommended in the MultiSource docs).
+ // This one is listed last so that if a particular version is available
+ // both in one of the above directories _and_ in a remote registry, the
+ // local copy will take precedence.
+ searchRules = append(searchRules, getproviders.MultiSourceSelector{
+ Source: getproviders.NewMemoizeSource(
+ getproviders.NewRegistrySource(services),
+ ),
+ })
+
+ return getproviders.MultiSource(searchRules)
+}


6. Найти все коммиты, в которых была изменена функция globalPluginDirs.

$git grep globalPluginDirs $(git rev-list --all)

41cb0d1f5029f4d0dfb20d985394d72a6636251a:command/cliconfig/config_unix.go: // FIXME: homeDir gets called from globalPluginDirs during init, before
41cb0d1f5029f4d0dfb20d985394d72a6636251a:commands.go: GlobalPluginDirs: globalPluginDirs(),
41cb0d1f5029f4d0dfb20d985394d72a6636251a:commands.go: helperPlugins := pluginDiscovery.FindPlugins("credentials", globalPluginDirs())
41cb0d1f5029f4d0dfb20d985394d72a6636251a:plugins.go:// globalPluginDirs returns directories that should be searched for
41cb0d1f5029f4d0dfb20d985394d72a6636251a:plugins.go:func globalPluginDirs() []string {

.....


7. Найти автора функции synchronizedWriters?

$git log -S "synchronizedWriters"

commit bdfea50cc85161dea41be0fe3381fd98731ff786
Author: James Bardin <j.bardin@gmail.com>
Date: Mon Nov 30 18:02:04 2020 -0500
remove unused

commit fd4f7eb0b935e5a838810564fd549afe710ae19a
Author: James Bardin <j.bardin@gmail.com>
Date: Wed Oct 21 13:06:23 2020 -0400
remove prefixed io
The main process is now handling what output to print, so it doesn't do
any good to try and run it through prefixedio, which is only adding
extra coordination to echo the same data.

commit 5ac311e2a91e381e2f52234668b49ba670aa0fe5
Author: Martin Atkins <mart@degeneration.co.uk>
Date: Wed May 3 16:25:41 2017 -0700
main: synchronize writes to VT100-faker on Windows
We use a third-party library "colorable" to translate VT100 color
sequences into Windows console attribute-setting calls when Terraform is
running on Windows.
colorable is not concurrency-safe for multiple writes to the same console,
because it writes to the console one character at a time and so two
concurrent writers get their characters interleaved, creating unreadable
garble.
Here we wrap around it a synchronization mechanism to ensure that there
can be only one Write call outstanding across both stderr and stdout,
mimicking the usual behavior we expect (when stderr/stdout are a normal
fle handle) of each Write being completed atomically.

$git show 5ac311e2a91e381e2f52234668b49ba670aa0fe5

commit 5ac311e2a91e381e2f52234668b49ba670aa0fe5
Author: Martin Atkins <mart@degeneration.co.uk>
Date: Wed May 3 16:25:41 2017 -0700
...
    
    
