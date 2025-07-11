#! /usr/bin/bash

# Exit Immediately if a command fails
set -e

cd "$(dirname "$0")"

DISTRO="${DISTRO:-unstable}"
MAINTAINER=$(git log -1 --pretty=format:'%an <%ae>')
ORIGIN=$(git remote get-url origin)

THEME_VARIANTS=('blissos' 'bassos' 'lineageos')
ICON_VARIANTS=('color' 'white')
SCREEN_VARIANTS=('1080p' '2k' '4k' 'ultrawide' 'ultrawide2k')

# Gen control
cat <<EOF >control
Source: grub-theme
Section: unknown
Priority: optional
Maintainer: $MAINTAINER
Rules-Requires-Root: no
Build-Depends:
 debhelper-compat (= 13),
Standards-Version: 4.6.2
Homepage: $ORIGIN
Vcs-Browser: $ORIGIN
Vcs-Git: $ORIGIN
EOF

for theme in "${THEME_VARIANTS[@]}"; do
	for icon in "${ICON_VARIANTS[@]}"; do
		for screen in "${SCREEN_VARIANTS[@]}"; do
			# Append to control file
			cat <<EOF >>control
Package: grub-theme-${theme}-${icon}-${screen}
Architecture: all
Multi-Arch: foreign
Depends: \${misc:Depends},
Description: GNU GRUB theme from BlissLabs, ${theme} variant, ${icon} icon pack, ${screen} resolution.

EOF
			# Create .install file
			echo "grub/${theme}-${icon}-${screen} usr/share/grub/themes" >"grub-theme-${theme}-${icon}-${screen}.install"
		done
	done
done

# Gen changelog (from latest commit)
MSG=$(git log -1 --pretty=format:'%s')
DATE=$(git log -1 --pretty=format:'%ad' --date=format:'%a, %d %b %Y %H:%M:%S %z')

# Generate changelog
cat <<EOF >changelog
grub-theme (1.1.0-1) $DISTRO; urgency=medium

$(echo -e "$MSG" | sed -r 's/^/  * /g')

 -- $MAINTAINER  $DATE

EOF
