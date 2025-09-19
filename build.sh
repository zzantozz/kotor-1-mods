!/bin/bash -e

die() {
  echo "ERROR: $1" >&2
  exit 1
}

output_game_dir="/d/games/steam-app/steamapps/common/swkotor"
output_ov_dir="$output_game_dir/Override"
output_tmp_dir="build/tmp"

mkdir -p "$output_ov_dir"

to_game_dir() {
  echo "Extract '$1' to game dir"
  files="$2"
  [ -z "$files" ] && files="*"
  /c/Program\ Files/7-Zip/7z.exe e -y -o"$output_game_dir" "$1" "$files" &>/dev/null || die "Failed to extract '$1'"
  return 0
}

to_ov_dir() {
  echo "Extract '$1' to override dir"
  to_tmp_dir_flat "$1" "$2"
  while [ -n "$3" ]; do
    rm -rf "$tmp_dir/$3"
    shift
  done
  cp -rv "$tmp_dir"/* "$output_ov_dir"
}

install_counter=1
run_installer() {
  out_dir="$output_tmp_dir/installer/$install_counter"
  echo "Extract '$1' to '$out_dir'"
  /c/Program\ Files/7-Zip/7z.exe x -y -o"$out_dir" "$1" &>/dev/null || die "Failed to extract '$1'"
  install_counter=$((install_counter+1))
  search="$2"
  [ -z "$search" ] && search="*.exe"
  exe="$(find "$out_dir" -iname "$search")"
  if [ "$(echo "$exe" | wc -l)" = 1 ]; then
    echo " - run installer"
    rel_dir="$(dirname "$exe")"
    echo " - installer location: D:\\games\\kotor\\${rel_dir////\\}"
    "$exe" || die "Installer failed"
  else
    die "Failed to find exactly one exe"
  fi
}

to_tmp_dir() {
  mkdir -p "$output_tmp_dir"
  tmp_dir="$(mktemp -d -p "$output_tmp_dir")"
  files="$2"
  [ -z "$files" ] && files="*"
  /c/Program\ Files/7-Zip/7z.exe x -y -o"$tmp_dir" "$1" "$files" &>/dev/null || die "Failed to extract '$1'"
}

to_tmp_dir_flat() {
  mkdir -p "$output_tmp_dir"
  files="$2"
  [ -z "$files" ] && files="*"
  tmp_dir="$(mktemp -d -p "$output_tmp_dir")"
  /c/Program\ Files/7-Zip/7z.exe e -y -o"$tmp_dir" "$1" "$files" &>/dev/null || die "Failed to extract '$1'"
  return 0
}

big_warning() {
  echo " ***************************************************************************"
  echo " ***************************************************************************"
  echo " **                                                                       **"
  echo " **  WARNING   WARNING   WARNING   WARNING   WARNING   WARNING   WARNING  **"
  echo " **  WARNING   WARNING   WARNING   WARNING   WARNING   WARNING   WARNING  **"
  echo " **  WARNING   WARNING   WARNING   WARNING   WARNING   WARNING   WARNING  **"
  echo " **                                                                       **"
  echo " ***************************************************************************"
  echo " ***************************************************************************"
  echo ''
}

to_game_dir 'mod-archives/KotOR_Dialogue_Fixes_5_2.7z' 'PC Response Moderation version\dialog.tlk'
run_installer './mod-archives/Character Start Up Changes.zip'
to_ov_dir './mod-archives/Character_Startup_Changes_Patch.zip' "Override/*"
run_installer './mod-archives/KOTOR1-Thematic-Companions_v1.0.1_spoiler-free.zip'

to_tmp_dir "./mod-archives/JC's Minor Fixes for K1 v1.1.zip"
cp -rv "$tmp_dir/Straight Fixes"/* "$output_ov_dir/"
cp -rv "$tmp_dir/Resolution Fixes"/* "$output_ov_dir/"
cp -rv "$tmp_dir/Aesthetic Improvements"/* "$output_ov_dir/"
for f in "$tmp_dir/Things What Bother Me Fixes"/*; do
  if [[ "$f" =~ /(N_AdmrlSaulKar.mdl|N_AdmrlSaulKar.mdx|N_SithComF.mdl|N_SithComF.mdx|N_SithComM.mdl|N_SithComM.mdx) ]]; then
    continue;
  fi
  cp "$f" "$output_ov_dir/"
done

run_installer 'mod-archives/Ajunta Pall Unique Appearance.zip'
to_ov_dir 'mod-archives\ajunta_pall_unique_appearance_1.1.rar' 'Transparent Skins/*.tga'

run_installer 'mod-archives/K1_Community_Patch_v1.10.0.zip'
to_ov_dir 'mod-archives/K1CP Patch.rar' 'K1CP Patch/*'

run_installer 'mod-archives/KotOR1 Droid Claw Fix.zip'

big_warning
echo "You have to do two installs: first the main mod, then the K1CP"
echo "compatibility patch! I will launch the installer twice, just to"
echo "be sure you don't goof up!"
big_warning

run_installer 'mod-archives/K1 PAVOR v1.3.2.7z'
run_installer 'mod-archives/K1 PAVOR v1.3.2.7z'

to_ov_dir 'mod-archives/Ultimate Korriban High Resolution - TPC Version-1367-1-2-1668960810.rar' 'Korriban HR/Override/*'
to_ov_dir 'mod-archives/Korriban Patch.7z'
to_ov_dir 'mod-archives/Ultimate Kashyyyk High Resolution - TPC Version-1365-1-2-1669476173.rar' 'Kashyyyk HR/Override/*'
to_ov_dir 'mod-archives/Ultimate Tatooine High Resolution - TPC Version-1364-1-2-1669474980.rar' 'Tatooine HR/Override/*'
to_ov_dir 'mod-archives/Ultimate Dantooine High Resolution - TPC Version-1368-1-2-1669481433.rar' 'Dantooine HR/Override/*'
to_ov_dir 'mod-archives/Ultimate Endar Spire-Star Forgre-Yavin Station - TPC Version-1370-1-1-1669482487.rar' 'Endar Spire - Yavin Station - Star Forge HR/Override/*'
to_ov_dir 'mod-archives/Ultimate Manaan High Resolution - TPC Version-1366-1-1-1669479766.rar' 'Manaan HR/Override/*'
to_ov_dir 'mod-archives/Ultimate Taris High Resolution - TPC Version-1360-2-3-1669473109.rar' 'Taris HR/Override/*' 'LSI_win01.tpc'
to_ov_dir 'mod-archives/Ultimate Character Overhaul -REDUX- ( LITE ) - TPC Version-1282-4-1-1628550322.rar' 'KOTOR - Ultimate Character Overhaul 4.1 LITE - TPC/*' 'PFBI01.tpc' 'PFBI02.tpc' 'PFBI03.tpc' 'PFBI04.tpc' 'PMBI01.tpc' 'PMBI02.tpc' 'PMBI03.tpc' 'PMBI04.tpc'
to_ov_dir 'mod-archives/Ultimate Unknown World High Resolution - TPC Version-1369-1-2-1675865873.rar' 'Unknown World HR/Override/*' 'LUN_blst01.tpc' 'LUN_blst02.tpc'

to_ov_dir 'mod-archives/Sith Art-1632-1-1713373365.zip' 'Override/*'
to_ov_dir 'mod-archives/Door Mural-1632-1-0-1713374023.zip' 'Override/*'
to_ov_dir 'mod-archives/Duncan on Manaan.7z'
to_ov_dir 'mod-archives/Consistent Conditioning Icons.7z' 'Consistent Condining Icons/Override/*'
to_ov_dir 'mod-archives/HD_Pazaak_Cards.zip' '*.tga'
to_ov_dir 'mod-archives/Scoundrel Trousers.zip' 'Scoundrel Trousers/*'
to_ov_dir "mod-archives/JC's Republic Soldier Fix for K1 v1.3.zip" 'Override/*'
to_ov_dir "mod-archives/JC's Republic Soldier Fix for K1 v1.3.zip" 'Optional/*'

big_warning
echo "Install options 3 and 5!"
big_warning

run_installer "mod-archives/[K1]_Republic_Soldier's_New_Shade_v1.1.1.7z"

to_ov_dir 'mod-archives/hd_pc_portraits-v1.0.7z' 'hd_pc_portraits/Override/*'
to_ov_dir 'mod-archives/PMHA05 HD.rar'
to_ov_dir 'mod-archives/PMHA02 HD.rar'
to_ov_dir 'mod-archives/PMHA01 HD.rar'
to_ov_dir 'mod-archives/PFHC05 HD.rar'
to_ov_dir 'mod-archives/[K1]_Player_Head_PFHB02_DS_Transition_Eye_Fix.7z' '[K1]_Player_Head_PFHB02_DS_Transition_Eye_Fix/UPSCALED/FOR OVERRIDE/*'
to_ov_dir 'mod-archives/hp_grenades-0-4-1209-0-4-1547556830.zip'
to_ov_dir 'mod-archives/Emperor Turnip&#39;s Gizka.rar' 'Creatures/*'
to_ov_dir 'mod-archives/Emperor Turnip&#39;s HD Rakghouls.rar' "Emperor Turnip's HD Rakghouls/*"
to_ov_dir 'mod-archives/Quanon_Gammoreans.rar' 'Quanon_Gammoreans/*'
to_ov_dir 'mod-archives/C_DrdWar.rar'
to_ov_dir 'mod-archives/AstromechHD.rar'

run_installer "mod-archives/K1 Twi'lek Heads v1.3.3.7z"

to_ov_dir 'mod-archives/hd_twilek_female.rar'
to_ov_dir 'mod-archives/[K1]_Thigh-High_Boots_For_Twilek_Body_MODDERS_RESOURCE.7z' '[K1]_Thigh-High_Boots_For_Twilek_Body_MODDERS_RESOURCE/NPC Replacement/*' 'OPTIONAL'
to_ov_dir 'mod-archives/K1 SL Mouth Adjustment v1.1.1.7z' 'Override/*'
to_ov_dir 'mod-archives/Calo Nord Recolor.zip' 'CN_Recolor/Calo Nord Reskin by Watcher07/Override/*'
to_ov_dir 'mod-archives/Malak.rar' 'N_DarthMalak01.tga'
to_ov_dir 'mod-archives/Malak.rar' 'Malak (Red Eyes)/*'
to_ov_dir "mod-archives/Detran's Darth Revan.zip"
to_ov_dir 'mod-archives/Darth Bandon HD.rar'
to_ov_dir 'mod-archives/HD Vrook Recolored.zip'
to_ov_dir 'mod-archives/Random HD UI Elements.7z' 'Random HD UI Elements/Override/*'
to_ov_dir 'mod-archives/hd_npc_portraits-v2.0.7z' 'hd_npc_portraits/Override/*'

run_installer 'mod-archives/JAO.7z'
run_installer 'mod-archives/JAO_Saber_Replacement.7z'

to_ov_dir 'mod-archives/juhaniCathar_head.zip'

big_warning
echo "Choose the 'community patch' option!"
echo "Optionally install alternate outfits for Uthar or Yuthura after the main patch."
big_warning

run_installer "mod-archives/JC's Korriban - Back in Black for K1 v2.3.zip"

big_warning
echo "Choose Brown-Red-Blue Alternative!"
big_warning
run_installer "mod-archives/JC's Fashion Line I - Cloaked Jedi Robes for K1 v1.4.7z"


run_installer "mod-archives/JC's Jedi Tailor for K1 v1.4.zip"

to_ov_dir 'mod-archives/Robes_With_Shadows_JC_K1_v1.2.0.7z' 'Robes_With_Shadows_JC_K1_v1.2.0/Jedi Robes Override/*'
to_ov_dir "mod-archives/Effixian's Qel-Droma Robes Reskin for JC's Cloaked Jedi Robes.zip" "Effixian's Qel-Droma Robes Reskin for JC's Cloaked Jedi Robes/Effixian's Qel-Droma Robes Reskin for JC's Cloaked Jedi Robes/*"
to_ov_dir 'mod-archives/Quanons_HK47_Reskin.rar' 'Quanons_HK47_Reskin/*' 'PO_phk47.tga'
to_ov_dir 'mod-archives/PLC_Sign.rar'
to_ov_dir 'mod-archives/Kiosk HD 15.03.2024.rar'
to_ov_dir 'mod-archives/plc_kiosk3_fixed.zip' 'K1/*'
to_ov_dir 'mod-archives/PLC_Desk.rar'
to_ov_dir 'mod-archives/LTS_EscapePod HD.rar'
to_ov_dir 'mod-archives/non-game weapon.rar'
to_ov_dir 'mod-archives/Stun baton HD.rar'

run_installer 'mod-archives/USG.rar'

to_ov_dir 'mod-archives/Ithorian HD.rar'
to_ov_dir 'mod-archives/Duros HD.rar'
to_ov_dir 'mod-archives/Qarren HD.rar'
to_ov_dir 'mod-archives/Davik HD.rar'
to_ov_dir 'mod-archives/DrdAstro HD.rar' '*' 'po_pt3m33.tga'
to_ov_dir 'mod-archives/DrdProtHD.rar'
to_ov_dir 'mod-archives/Carth Onasi (new clothes).rar' '*' 'po_pcarth3.tga'
to_ov_dir 'mod-archives/Canderous OrdoHD (new clothes).rar'
to_ov_dir 'mod-archives/Canderous Patch.rar'
to_ov_dir 'mod-archives/Quanon_CandOrdo_Reskin.rar' 'Quanon_CandOrdo_Reskin/P_CandH01.tga'
to_ov_dir 'mod-archives/Jolee Bindo HD — clothes.rar'
to_ov_dir "mod-archives/Fen's - Jolee-1192-1.zip" 'Fens - Jolee\Fens - Jolee/P_joleeh01.tga'
to_ov_dir "mod-archives/Fen's - Jolee-1192-1.zip" 'Fens - Jolee\Fens - Jolee/P_joleeh01.txi'
to_ov_dir 'mod-archives/ZaalbarHD.rar' '*' 'po_pzaalbar3.tga'
to_ov_dir "mod-archives/Heyorange's Sith Uniform Reformation 1.0.zip" "1. Heyorange's Sith Uniform Reformation/Override/*" 'kor35_sithguard.utc' 'kor35_sithguard2.utc' 'kor35_sithguard3.utc' 'kor35_sithguard4.utc' 'kor36_sithguard1.utc'
to_ov_dir 'mod-archives/Star-Map_Revamp_1-1.zip' 'Star-Map_Revamp_1-1/*'
to_ov_dir 'mod-archives/hd_kt_400_military_droid_carrier_and_lethisk_class_armed_freighter.rar'
to_ov_dir 'mod-archives/vurt_k1_eh_retexture_v10.rar'
cp "$output_ov_dir/LDA_EHawk01.tga" "$output_ov_dir/M36_EHawk01.tga"

to_ov_dir 'mod-archives/Ultimate_Ebon_Hawk_Repairs_For_K1_v2.0.0.7z' 'Ultimate_Ebon_Hawk_Repairs_For_K1_v2.0.0/To Override/*'
to_ov_dir 'mod-archives/Ultimate_Ebon_Hawk_Repairs_For_K1_v2.0.0.7z' 'Ultimate_Ebon_Hawk_Repairs_For_K1_v2.0.0/Animated Monitors/*'
to_ov_dir 'mod-archives/High Quality Cockpit Skyboxes M.zip' 'High Quality Cockpit Skyboxes M/Override/*'
to_ov_dir 'mod-archives/SH_EHCockpitUpgrade_LEH_Scre01_MS.7z'
to_ov_dir 'mod-archives/SH_EHCockpitUpgrade_LEH_Scre02.7z' 'No Overlays/*'
to_ov_dir 'mod-archives/Taris_Reskin-10-1-0.zip' 'Taris_Reskin/Taris_TexturePack/Taris_Tex_Part1/*' 'LTS_Bsky01.tga' 'LTS_Bsky02.tga' 'LTS_sky0001.tga' 'LTS_sky0002.tga' 'LTS_sky0003.tga' 'LTS_SKY0004.tga' 'LTS_SKY0005.tga'
to_ov_dir 'mod-archives/Taris_Reskin-10-1-0.zip' 'Taris_Reskin/Taris_TexturePack/Taris_Tex_Part2/*'
to_ov_dir 'mod-archives/Taris Reskin Patch.7z' 'Taris Reskin Patch/*'
to_ov_dir 'mod-archives/K1_HDStarsAndNebulasCENSORED.rar' 'K1_HDStarsAndNebulas/*'
to_ov_dir 'mod-archives/HQSkyboxesII_K1.7z' 'Override/*' 'm36aa_01_lm0.tga' 'm36aa_01_lm1.tga' 'm36aa_01_lm2.tga'
to_ov_dir 'mod-archives/K1 Ebon Hawk Transparent Cockpit Windows v1_1_1.7z' 'Main Installation/Override/*'
to_ov_dir 'mod-archives/K1 Ebon Hawk Transparent Cockpit Windows v1_1_1.7z' 'Compatibility Patches/Leviathan - K1CP Forcefield/*'
to_ov_dir 'mod-archives/K1 Ebon Hawk Transparent Cockpit Windows v1_1_1.7z' 'Compatibility Patches/High Quality Skyboxes by Kexikus/*'
to_ov_dir 'mod-archives/DI_HRBM_2.7z'
to_ov_dir 'mod-archives/FireandIceHDWhee.zip'
to_ov_dir 'mod-archives/Animated energy shields.rar'
to_ov_dir 'mod-archives/SH_AnimatedCantinaSign.7z'
to_ov_dir 'mod-archives/PLC_CompPnl.rar'
to_ov_dir 'mod-archives/RepTab HD.rar'
to_ov_dir 'mod-archives/[K1]_Animated_Swoop_Screen_[TSLPort].7z' '[K1]_Animated_Swoop_Screen_[TSLPort]/to_Override/*'
to_ov_dir 'mod-archives/Loadscreens in Color.zip' 'Override/*'

big_warning
echo "Only standard is recommended. Other options aren't tested"
big_warning
run_installer 'mod-archives/New_Lightsaber_Blades_K1_v_1.rar'

to_ov_dir "mod-archives/JC's Blaster Visual Effects for K1.zip" 'Override/*'
to_ov_dir 'mod-archives/WookieWarbladeFix-Redrob41.7z'

run_installer 'mod-archives/KillCzerkaJerk.zip' 'TSLPatcher.exe'

to_ov_dir 'mod-archives/di_kaw2.7z' '*' 'Source'
to_ov_dir 'mod-archives/Senni Vek Restoration CENSORED.rar' 'Senni Vek Restoration/For Override/*'

big_warning
echo "Install two: the main mod and the SenniVek Restoration (not Ambush)"
big_warning
run_installer "mod-archives/K1 Twi'lek Male NPC Diversity.7z"

to_ov_dir "mod-archives/K1 Twi'lek Male NPC Diversity.7z" "KotOR 1 Twi'lek Male NPC Diversity/Optional - Upscaled Textures/*"

run_installer 'mod-archives/CK-Ixgil the Bith.zip'

to_ov_dir 'mod-archives/Bek Control Room Restoration 1.1.zip' 'Bek Control Room Restoration 1.1/For Override/*'
to_ov_dir 'mod-archives/JCDE.7z' 'JCDE/dan13_dorak.dlg'
to_ov_dir 'mod-archives/J Dialogue Restoration.7z' 'J Dialogue Restoration/Installation/*'

run_installer "mod-archives/JC's Vision Enhancement for K1 v1.2.zip"

to_ov_dir 'mod-archives/LDD.rar' 'LDD/*'
to_ov_dir 'mod-archives/Balanced Pazaak.zip' 'Override/*'
to_ov_dir 'mod-archives/ebon_hawk_camera.zip' 'ebon_hawk_camera/*'
to_ov_dir 'mod-archives/Improved Grenades.7z' 'Improved Grenades/Improved Grenades/Vanilla Increased Radius +Demo/*'
to_ov_dir 'mod-archives/Grenades and mines HD.rar' '*' 'ii_trapkit_001.tga' 'ii_trapkit_002.tga' 'ii_trapkit_003.tga' 'ii_trapkit_004.tga'

run_installer 'mod-archives/K1_Taris_Sith_Uniform_Disguise_Extension_v1.1.zip'
run_installer "mod-archives/JC's Leviathan - Ain't No Air In Space for K1.zip"

big_warning
echo "Use the K1CP compatible option!"
big_warning
run_installer 'mod-archives/K1 Party Conversations on Ebon Hawk v1_3.zip'

run_installer "mod-archives/JC's Romance Enhancement - Dark Sacrifice for K1 v1.0.zip"
run_installer 'mod-archives/saberthrow_kd.zip'
run_installer 'mod-archives/SMRE Version 3.0.zip'

big_warning
echo "Author recommends option 2."
big_warning
run_installer "mod-archives/PC Dialogue with Davik's Slaves Change.7z"

run_installer "mod-archives/JC's Security Spikes for K1 v1.2.zip"

big_warning
echo "One error is intended! This mod was modified before installation."
big_warning
to_tmp_dir 'mod-archives/High Quality Blasters 1.1.zip'
base_dir="$tmp_dir/High Quality Blasters 1.1"
rm "$base_dir/tslpatchdata/keblastore.utm" || die "Failed to delete file as instructed"
"$base_dir/High Quality Blasters Installer.exe"
mv "$output_ov_dir/w_ionrfl_04.mdl" "$output_ov_dir/w_ionrfl_004.mdl" || die "Failed to rename file as instructed"
mv "$output_ov_dir/w_ionrfl_04.mdx" "$output_ov_dir/w_ionrfl_004.mdx" || die "Failed to rename file as instructed"
rm "$output_ov_dir/w_rptnblstr_004.mdl" || die "Failed to remove file as instructed"
rm "$output_ov_dir/w_rptnblstr_004.mdx" || die "Failed to remove file as instructed"
rm "$output_ov_dir/w_blstrpstl_006.mdl" || die "Failed to remove file as instructed"
rm "$output_ov_dir/w_blstrpstl_006.mdx" || die "Failed to remove file as instructed"
rm "$output_ov_dir/g1_w_rptnblstr01.uti" || die "Failed to remove file as instructed"

big_warning
echo "We'll run this three times: first, install the mod, then install loadscreens and HQ blasters."
big_warning
run_installer 'mod-archives/ldr_repshipunknownworld.zip'
run_installer 'mod-archives/ldr_repshipunknownworld.zip'
run_installer 'mod-archives/ldr_repshipunknownworld.zip'

run_installer 'mod-archives/[K1]_Trandoshans_Rescale.7z'
run_installer 'mod-archives/Custom Selkath Animation.rar'
run_installer 'mod-archives/Bastila Has Battle Meditation.zip' 'TSLPatcher.exe'
run_installer 'mod-archives/Sneak Attack 10 Restoration.zip'
run_installer 'mod-archives/KOTOR1-Thematic-The-One_v1.0.2_spoiler-free.zip'
run_installer 'mod-archives/SAwL CENSORED.rar'
to_ov_dir 'mod-archives/SAWL Patch.rar' 'SAWL Patch/Override/*'

big_warning
echo "This mod failed when installing standalone - couldn't find appearance.2da file. Maybe it'll work in a full install?"
run_installer 'mod-archives/HSI.7z'
run_installer 'mod-archives/BDB.7z'
run_installer 'mod-archives/[K1]_Taris_Dueling_Arena_Adjustment_v1.4.7z'
cp -D 'mod-archives/tar02_duelorg021.dlg' "$output_ov_dir"

run_installer 'mod-archives/[K1]_Control_Panel_For_Kashyyyk_Shadowlands_Forcefield_v1.1.7z'
run_installer 'mod-archives/[K1]_Vulkar_Accel_Bench_v1.0.1.7z'

big_warning
echo "Only install the pillar facing fix."
run_installer 'mod-archives/[K1]_UWTMF_Missing_Lamps_Fix_v1.0.0.7z'

run_installer "mod-archives/JC's Czerka - Business Attire for K1.zip"
to_ov_dir 'mod-archives/Czerka Business Attire - Dark Hope Ithorian Compatch.7z'

run_installer 'mod-archives/Sith Soldier Texture Restoration-v2.4.zip'
run_installer 'mod-archives/[K1]_Diversified_Wounded_Republic_Soldiers_On_Taris_v1.4.7z'
run_installer 'mod-archives/[K1]_DJC_v1.2_R-KOTOR_BUILD.7z'
run_installer 'mod-archives/JRE.7z'

big_warning
echo "Author suggests 'Revisited' option"
run_installer "mod-archives/[K1]_Dodonna's_Transmission_v1.1 CENSORED.rar"

run_installer 'mod-archives/[K1]_Movie-Style_Holograms_v1.1_R-KOTOR_BUILD.7z'
run_installer 'mod-archives/[K1]_Movie-Style_Holograms_For_Twisted_Rancor_Trio_Puzzle.7z'
run_installer 'mod-archives/[K1]_Movie-Style_Holograms_Part2_v1.1_R-KOTOR_BUILD.7z'
run_installer 'mod-archives/Droid Unique VO.rar'

big_warning
echo "Use the version that's not for the Weapon Model Overhaul"
run_installer 'mod-archives/Ajunta&#39;s Swords.7z'

big_warning
echo "Install the Sith Specter/Rece compatibility option"
run_installer "mod-archives/[K1]_Legends_Ajunta_Pall's_Blade_v1.0.2b.7z"

big_warning
echo "ONLY install option A."
run_installer "mod-archives/JC's Mandalorian Armor for K1 v1.2.zip"

run_installer 'mod-archives/Weapon Base Stats Re-balance K1.rar'
run_installer 'mod-archives/Gaffi Stick Improvement.zip'
to_ov_dir 'mod-archives/QSRPK1.7z' 'QSRPK1/For Override/*'
run_installer 'mod-archives/DTL.rar'
run_installer 'mod-archives/Logical Datapads.7z'
run_installer 'mod-archives/visual_effects_k1.7z'
run_installer 'mod-archives/CK-Minor music tweaks.zip'
run_installer 'mod-archives/NPC_Alignment_Fix_v1_1.rar'

big_warning
echo "Apparently need to stop here and go do widescreen stuff, or you can just continue ..."
echo "https://kotor.neocities.org/modding/mod_builds/k1/spoiler-free#Optional_Widescreen"

# Mods I've downloaded for widescreen, so I can audit downloads vs this script:
# '[K1]_Main_Menu_Widescreen_Fix_v1.2.7z'
# '[K1]_Workbench_Upgrade_Screen_Camera_Tweak.7z'
# "HD Robe Icons for JC's Cloaked Jedis and Effix's Extra Robes.zip"
# 'hd_ui_menupack_PV.7z'
# 'k1hrm-1.5.7z'
# 'KOTOR 1 Fade widescreen fix.zip'
# 'Pretty Good! Icons for KotOR 1.0.7z'
# 'Upscaled Computer.rar'
# 'ws models for swkotor-1211-0-22-1550195260.zip'
# 'Resolution 2560x1440-1306-1-1-1575389956.zip'
# 'KOTOR Editable Executable.rar'
# 'uniws.zip'

read -p "Enter to continue ... " bleha

# If widescreen was done, then can apply '4gb_patch.zip'
# Otherwise, continue on

run_installer 'mod-archives/Galaxy Map Fix Pack CENSORED.rar'
## would install 'HR Menu Patch.zip" here, if doing widescreen
read -p "If you want to widescreen, you need to add the appropriate path for the previous mod here. Enter to continue..."

to_game_dir 'mod-archives/Remove Duplicate TGA-TPC-1384-1-2-1616219479.zip'
big_warning
echo "Say that TCP should be deleted and don't manually confirm!"
echo "If it says it finished but didn't delete any files, it didn't work!"
"$output_game_dir/DelDuplicateTGA-TPC.bat"

run_installer 'mod-archives/
run_installer 'mod-archives/

to_ov_dir "mod-archives/JC's Minor Fixes - Compatibility Patch-1282-4-1-1629713341.rar" "JC's Minor Fixes - Patch/Aesthetic Improvements/*"
to_ov_dir "mod-archives/JC's Minor Fixes - Compatibility Patch-1282-4-1-1629713341.rar" "JC's Minor Fixes - Patch/Resolution Fixes/*"
to_ov_dir "mod-archives/JC's Minor Fixes - Compatibility Patch-1282-4-1-1629713341.rar" "JC's Minor Fixes - Patch/Straight Fixes/*"
to_ov_dir 'mod-archives/KOTOR 1 Community Patch - Compatibility Patch-1282-4-1-1629713397.rar' 'KOTOR 1 Community Patch - Patch/*'
to_ov_dir "mod-archives/Better Twi'lek Male Heads - Compatibility Patch-1282-4-1-1629713230.rar" "Better Twi'lek Male Heads - Patch/Textures/*"
to_ov_dir "mod-archives/JC's Mandalorian Armor - Compatibility Patch-1282-4-1-1629713289.rar" "JC's Mandalorian Armor - Patch/Option A/*"
to_ov_dir 'mod-archives/Miscellaneous Compatibility Patches-1282-4-1-1629713437.rar' 'Miscellaneous Compatibility Patches/Juhani Cathar Head - Patch/*'
to_ov_dir 'mod-archives/Miscellaneous Compatibility Patches-1282-4-1-1629713437.rar' "Miscellaneous Compatibility Patches/Thigh-High Boots for Twi'lek - Patch/NPC Replacement/*.tga"
to_ov_dir "mod-archives/Republic Soldier's New Shade - Compatibility Patch-1282-4-1-1629713494.rar" "Republic Soldier's New Shade - Patch/New Shade/*"

big_warning
echo "Can only apply the 4GB patch with Steam if the widescreen mods have been done!"
echo "See https://kotor.neocities.org/modding/mod_builds/k1/spoiler-free#4GB_Patcher" 
echo "Also see earlier step that requires widescreen."
read -p "Enter to continue..." bleh

