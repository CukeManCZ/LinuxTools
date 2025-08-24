#!/bin/bash
# Installation of custom keyboard  "Czech (numbers on top)" pro XKB

set -e

# 1. Backup
sudo cp /usr/share/X11/xkb/symbols/cz /usr/share/X11/xkb/symbols/cz.bak
sudo cp /usr/share/X11/xkb/rules/evdev.xml /usr/share/X11/xkb/rules/evdev.xml.bak
sudo cp /usr/share/X11/xkb/rules/evdev.lst /usr/share/X11/xkb/rules/evdev.lst.bak

# 2. Add variant into  /usr/share/X11/xkb/symbols/cz
sudo tee -a /usr/share/X11/xkb/symbols/cz > /dev/null <<'EOF'

xkb_symbols "numbers" {

    include "latin"
    name[Group1]= "Czech (numbers on top)";

    key <TLDE>  {[ semicolon, dead_abovering,    grave,   asciitilde ]};

    key <AE01>  {[ 1, plus,       exclam,   dead_tilde ]};
    key <AE02>  {[ 2, ecaron,         at,   dead_caron ]};
    key <AE03>  {[ 3, scaron,  numbersign, dead_circumflex ]};
    key <AE04>  {[ 4, ccaron,     dollar,   dead_breve ]};
    key <AE05>  {[ 5, rcaron,    percent, dead_abovering ]};
    key <AE06>  {[ 6, zcaron, asciicircum,  dead_ogonek ]};
    key <AE07>  {[ 7, yacute,   ampersand,   dead_grave ]};
    key <AE08>  {[ 8, aacute,   asterisk, dead_abovedot]};
    key <AE09>  {[ 9, iacute,  braceleft,   dead_acute ]};
    key <AE10>  {[ 0, eacute, braceright, dead_doubleacute ]};

    key <AE11>  {[ equal,    percent,     NoSymbol, dead_diaeresis ]};
    key <AE12>  {[ dead_acute, dead_caron,  dead_macron, dead_cedilla ]};

    key <AD01>  {[ q, Q, backslash, NoSymbol ]};
    key <AD02>  {[ w, W, bar, NoSymbol ]};
    key <AD03>  {[ e, E, EuroSign, NoSymbol ]};
    key <AD04>  {[ r, R, NoSymbol, NoSymbol ]};
    key <AD05>  {[ t, T, NoSymbol, NoSymbol ]};
    key <AD06>  {[ z, Z, NoSymbol, NoSymbol ]};
    key <AD07>  {[ u, U, NoSymbol, NoSymbol ]};
    key <AD08>  {[ i, I, NoSymbol, NoSymbol ]};
    key <AD09>  {[ o, O, NoSymbol, NoSymbol ]};
    key <AD10>  {[ p, P, NoSymbol, NoSymbol ]};
    key <AD11>  {[ uacute, slash, bracketleft, division ]};
    key <AD12>  {[ parenright, parenleft, bracketright, multiply ]};

    key <AC01>  {[ a, A, asciitilde, NoSymbol ]};
    key <AC02>  {[ s, S, dstroke, NoSymbol ]};
    key <AC03>  {[ d, D, Dstroke, NoSymbol ]};
    key <AC04>  {[ f, F, bracketleft, NoSymbol ]};
    key <AC05>  {[ g, G, bracketright, NoSymbol ]};
    key <AC06>  {[ h, H, grave, NoSymbol ]};
    key <AC07>  {[ j, J, apostrophe, NoSymbol ]};
    key <AC08>  {[ k, K, lstroke, NoSymbol ]};
    key <AC09>  {[ l, L, Lstroke, NoSymbol ]};
    key <AC10>  {[ uring, quotedbl, dollar, NoSymbol ]};
    key <AC11>  {[ section, exclam, apostrophe, ssharp ]};
    key <BKSL>  {[ dead_diaeresis, apostrophe, backslash, bar ]};

    key <LSGT>  {[ backslash, bar, slash, NoSymbol ]};
    key <AB01>  {[ y, Y, degree, NoSymbol ]};
    key <AB02>  {[ x, X, numbersign, NoSymbol ]};
    key <AB03>  {[ c, C, ampersand, NoSymbol ]};
    key <AB04>  {[ v, V, at, NoSymbol ]};
    key <AB05>  {[ b, B, braceleft, NoSymbol ]};
    key <AB06>  {[ n, N, braceright, NoSymbol ]};
    key <AB07>  {[ m, M, asciicircum, NoSymbol ]};
    key <AB08>  {[ comma, question, less, NoSymbol ]};
    key <AB09>  {[ period, colon, greater, NoSymbol ]};
    key <AB10>  {[ minus, underscore, asterisk, NoSymbol ]};

    key <SPCE>  {[ space, space, space, space ]};

    include "level3(ralt_switch)"
};
EOF

# 3. Edit evdev.xml
if ! grep -q 'Czech (numbers on top)' /usr/share/X11/xkb/rules/evdev.xml; then
  sudo sed -i '/<layout>\s*<configItem>\s*<name>cz<\/name>/,/<\/variantList>/ s|</variantList>|<variant>\n  <configItem>\n    <name>numbers</name>\n    <description>Czech (numbers on top)</description>\n  </configItem>\n</variant>\n</variantList>|' /usr/share/X11/xkb/rules/evdev.xml
fi

# 4. Edit evdev.lst
if ! grep -q 'cz: Czech (numbers on top)' /usr/share/X11/xkb/rules/evdev.lst; then
  echo "  numbers         cz: Czech (numbers on top)" | sudo tee -a /usr/share/X11/xkb/rules/evdev.lst
fi

echo "For imidiate run: setxkbmap cz -variant numbers"

