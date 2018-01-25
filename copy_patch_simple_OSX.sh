#! /bin/sh
#
# This script is the first of a triology:
# copy_patch_simple_OSX.sh, copy_patch_with_hide_OSX.sh, patch_mexs_OSX.sh   
# Run them in that order from a sub-directory of the mirone root dir
#
# However, don't forget to first: update GMT, rebuild gmtmex, build the mexs in the mex dir
#
# What they do is to copy several dylibs from /usr/local/lib (built with Homebrew) and strip the
# hard-coded paths. Besides that, several of those shared libs are assigned a different name
# (by appending a '_hide') so that Matlab does not managed to f. in the middle with its own outdated
# versions. For example libhdf5.dylib will become libhdf5_hide.dylib

# Copy and patch the dylibs that don't need the replaced names. Those are dealt by "copy_patch_with_hide_OSX.sh"

# $Id :

lib_loc=/usr/local/lib

# ------------------------- OpenCV libs -------------------------
cp -f ${lib_loc}/libopencv_core.2.4.dylib .
ln -s -f libopencv_core.2.4.dylib libopencv_core.dylib

cp -f ${lib_loc}/libopencv_imgproc.2.4.dylib .
ln -s -f libopencv_imgproc.2.4.dylib libopencv_imgproc.dylib 

cp -f ${lib_loc}/libopencv_calib3d.2.4.dylib .
ln -s -f libopencv_calib3d.2.4.dylib libopencv_calib3d.dylib

cp -f ${lib_loc}/libopencv_objdetect.2.4.dylib .
ln -s -f libopencv_objdetect.2.4.dylib libopencv_objdetect.dylib 

cp -f ${lib_loc}/libopencv_video.2.4.dylib .
ln -s -f libopencv_video.2.4.dylib libopencv_video.dylib

cp -f ${lib_loc}/libopencv_photo.2.4.dylib .
ln -s -f libopencv_photo.2.4.dylib libopencv_photo.dylib

cp -f ${lib_loc}/libopencv_highgui.2.4.dylib .
ln -s -f libopencv_highgui.2.4.dylib libopencv_highgui.dylib

cp -f ${lib_loc}/libopencv_features2d.2.4.dylib .
ln -s -f libopencv_features2d.2.4.dylib libopencv_features2d.dylib

cp -f ${lib_loc}/libopencv_flann.2.4.dylib .
ln -s -f libopencv_flann.2.4.dylib libopencv_flann.dylib


# ------------------------- GDAL libs ---------------------------
# WE don't copy those that are dealt by "copy_patch_with_hide.sh"

cp -f ${lib_loc}/libjson-c.2.dylib .
ln -s -f libjson-c.2.dylib libjson-c.dylib

cp -f ${lib_loc}/libfreexl.1.dylib .
ln -s -f libfreexl.1.dylib libfreexl.dylib

cp -f ${lib_loc}/libwebp.7.dylib .
ln -s -f libwebp.7.dylib libwebp.dylib

cp -f ${lib_loc}/libodbc.2.dylib .
ln -s -f libodbc.2.dylib libodbc.dylib

cp -f ${lib_loc}/libodbcinst.2.dylib .
ln -s -f libodbcinst.2.dylib libodbcinst.dylib

cp -f ${lib_loc}/libgif.4.dylib .
ln -s -f libgif.4.dylib libgif.dylib

cp -f ${lib_loc}/libjpeg.8.dylib .
ln -s -f libjpeg.8.dylib libjpeg.dylib

cp -f ${lib_loc}/libpng16.16.dylib .
ln -s -f libpng16.16.dylib libpng16.dylib

cp -f ${lib_loc}/liblzma.5.dylib .
ln -s -f liblzma.5.dylib liblzma.dylib

cp -f /usr/local/opt/libxml2/lib/libxml2.2.dylib .
ln -s -f libxml2.2.dylib libxml2.dylib

cp -f /usr/local/opt/sqlite/lib/libsqlite3.0.dylib .
ln -s -f libsqlite3.0.dylib libsqlite3.dylib

cp -f ${lib_loc}/libsz.2.dylib .
ln -s -f libsz.2.dylib libsz.dylib

cp /usr/local/opt/geos/lib/libgeos-3.6.1.dylib .
ln -s -f libgeos-3.6.1.dylib libgeos-3.dylib 

cp /usr/local/lib/libpopt.0.dylib .
ln -s -f libpopt.0.dylib libpopt.dylib

cp -f ${lib_loc}/libpcre.1.dylib .
ln -s -f libpcre.1.dylib libpcre.dylib

cp -f ${lib_loc}/libfftw3f.3.dylib .
ln -s -f libfftw3f.3.dylib libfftw3f.dylib

cp /usr/local/lib/libImath-2_2.12.dylib .
ln -s -f libImath-2_2.12.dylib libImath-2_2.dylib

cp /usr/local/lib/libIlmImf-2_2.22.dylib .
ln -s -f libIlmImf-2_2.22.dylib libIlmImf-2_2.dylib

cp /usr/local/lib/libIex-2_2.12.dylib .
ln -s -f libIex-2_2.12.dylib libIex-2_2.dylib

cp /usr/local/lib/libHalf.12.dylib .
ln -s -f libHalf.12.dylib libHalf.dylib

cp /usr/local/lib/libIlmThread-2_2.12.dylib .
ln -s -f libIlmThread-2_2.12.dylib libIlmThread-2_2.dylib

chmod +w *.dylib

# GDAL exes (Shit, these carry again the whole trunk of dependencies to patch)
#cp -f /usr/local/bin/gdalinfo .
#cp -f /usr/local/bin/gdal_translate .

# ------------------------------------------------------------------
#               NOW THE PATCHING PART
# ------------------------------------------------------------------


install_name_tool -id libjpeg.dylib        libjpeg.8.dylib
install_name_tool -id libpng16.dylib       libpng16.16.dylib
install_name_tool -id libjson-c.dylib      libjson-c.2.dylib
install_name_tool -id libfreexl.dylib      libfreexl.1.dylib
install_name_tool -id libwebp.dylib        libwebp.7.dylib
install_name_tool -id liblzma.dylib        liblzma.5.dylib
install_name_tool -id libsqlite3.dylib     libsqlite3.0.dylib
install_name_tool -id libpcre.dylib        libpcre.1.dylib
install_name_tool -id libxml2.dylib        libxml2.2.dylib
install_name_tool -id libgeos-3.dylib      libgeos-3.6.1.dylib
install_name_tool -id libfftw3f.dylib      libfftw3f.3.dylib
install_name_tool -id libpopt.dylib        libpopt.0.dylib
install_name_tool -id libsz.dylib          libsz.2.dylib
install_name_tool -id libgif.dylib         libgif.4.dylib
install_name_tool -id libodbc.dylib        libodbc.2.dylib
install_name_tool -id libodbcinst.dylib    libodbcinst.2.dylib
install_name_tool -id libImath-2_2.dylib   libImath-2_2.12.dylib
install_name_tool -id libIlmImf-2_2.dylib  libIlmImf-2_2.22.dylib
install_name_tool -id libIex-2_2.dylib     libIex-2_2.12.dylib
install_name_tool -id libHalf.dylib        libHalf.12.dylib
install_name_tool -id libIlmThread-2_2.dylib libIlmThread-2_2.12.dylib


cp -f ${lib_loc}/libjasper.4.dylib .
chmod +w libjasper.4.dylib
install_name_tool -id libjasper.dylib      libjasper.4.dylib

var_shit=`otool -L libjasper.4.dylib | tail -n +3 | awk '{print $1}' | grep libjasper`
if [[ ${var_shit:0:1} == *"/"* ]]; then
install_name_tool -change ${var_shit} libjpeg.dylib libjasper.4.dylib
fi
mv libjasper.4.dylib libjasper.dylib


cp -f ${lib_loc}/libdap.23.dylib .
chmod +w libdap.23.dylib
install_name_tool -id libdap.dylib         libdap.23.dylib

var_shit=`otool -L libdap.23.dylib | tail -n +3 | awk '{print $1}' | grep libxml2`
if [[ ${var_shit:0:1} == *"/"* ]]; then
install_name_tool -change ${var_shit} libxml2.dylib libdap.23.dylib
fi

var_shit=`otool -L libdap.23.dylib | tail -n +3 | awk '{print $1}' | grep libcrypto`
if [[ ${var_shit:0:1} == *"/"* ]]; then
install_name_tool -change ${var_shit} libcrypto.dylib libdap.23.dylib
fi
mv libdap.23.dylib libdap.dylib

cp -f ${lib_loc}/libdapserver.7.dylib .
chmod +w libdapserver.7.dylib
install_name_tool -id libdapserver.dylib   libdapserver.7.dylib

var_shit=`otool -L libdapserver.7.dylib | tail -n +3 | awk '{print $1}' | grep libdap`
if [[ ${var_shit:0:1} == *"/"* ]]; then
install_name_tool -change ${var_shit} libdap.dylib libdapserver.7.dylib
fi

var_shit=`otool -L libdapserver.7.dylib | tail -n +3 | awk '{print $1}' | grep libxml2`
if [[ ${var_shit:0:1} == *"/"* ]]; then
install_name_tool -change ${var_shit} libxml2.dylib libdapserver.7.dylib
fi

var_shit=`otool -L libdapserver.7.dylib | tail -n +3 | awk '{print $1}' | grep libcrypto`
if [[ ${var_shit:0:1} == *"/"* ]]; then
install_name_tool -change ${var_shit} libcrypto.dylib libdapserver.7.dylib
fi
mv  libdapserver.7.dylib libdapserver.dylib

cp -f ${lib_loc}/libdapclient.6.dylib .
chmod +w libdapclient.6.dylib
install_name_tool -id libdapclient.dylib   libdapclient.6.dylib

var_shit=`otool -L libdapclient.6.dylib | tail -n +3 | awk '{print $1}' | grep libdap`
if [[ ${var_shit:0:1} == *"/"* ]]; then
install_name_tool -change ${var_shit} libdap.dylib libdapclient.6.dylib
fi

var_shit=`otool -L libdapclient.6.dylib | tail -n +3 | awk '{print $1}' | grep libxml2`
if [[ ${var_shit:0:1} == *"/"* ]]; then
install_name_tool -change ${var_shit} libxml2.dylib libdapclient.6.dylib
fi

var_shit=`otool -L libdapclient.6.dylib | tail -n +3 | awk '{print $1}' | grep libcrypto`
if [[ ${var_shit:0:1} == *"/"* ]]; then
install_name_tool -change ${var_shit} libcrypto.dylib libdapclient.6.dylib
fi
mv libdapclient.6.dylib libdapclient.dylib


cp -f ${lib_loc}/libspatialite.7.dylib .
chmod +w libspatialite.7.dylib
install_name_tool -id libspatialite.dylib  libspatialite.7.dylib

var_shit=`otool -L libspatialite.7.dylib | tail -n +3 | awk '{print $1}' | grep libxml2`
if [[ ${var_shit:0:1} == *"/"* ]]; then
install_name_tool -change ${var_shit} libxml2.dylib libspatialite.7.dylib
fi

var_shit=`otool -L libspatialite.7.dylib | tail -n +3 | awk '{print $1}' | grep libfreexl`
if [[ ${var_shit:0:1} == *"/"* ]]; then
install_name_tool -change ${var_shit} libfreexl.dylib libspatialite.7.dylib
fi

var_shit=`otool -L libspatialite.7.dylib | tail -n +3 | awk '{print $1}' | grep libproj`
if [[ ${var_shit:0:1} == *"/"* ]]; then
install_name_tool -change ${var_shit} libproj_hide.dylib libspatialite.7.dylib
fi

var_shit=`otool -L libspatialite.7.dylib | tail -n +3 | awk '{print $1}' | grep libsqlite3`
if [[ ${var_shit:0:1} == *"/"* ]]; then
install_name_tool -change ${var_shit} libsqlite3.dylib libspatialite.7.dylib
fi

var_shit=`otool -L libspatialite.7.dylib | tail -n +3 | awk '{print $1}' | grep liblwgeom`
if [[ ${var_shit:0:1} == *"/"* ]]; then
install_name_tool -change ${var_shit} liblwgeom-2.dylib libspatialite.7.dylib
fi

var_shit=`otool -L libspatialite.7.dylib | tail -n +3 | awk '{print $1}' | grep libgeos_c`
if [[ ${var_shit:0:1} == *"/"* ]]; then
install_name_tool -change ${var_shit} libgeos_c_hide.dylib libspatialite.7.dylib
fi

var_shit=`otool -L libspatialite.7.dylib | tail -n +3 | awk '{print $1}' | grep libproj`
if [[ ${var_shit:0:1} == *"/"* ]]; then
install_name_tool -change ${var_shit} libproj_hide.dylib libspatialite.7.dylib
fi
mv libspatialite.7.dylib libspatialite.dylib


cp /usr/local/opt/liblwgeom/lib/liblwgeom-2.1.5.dylib .
chmod +w liblwgeom-2.1.5.dylib
install_name_tool -id liblwgeom-2.dylib    liblwgeom-2.1.5.dylib

var_shit=`otool -L liblwgeom-2.1.5.dylib | tail -n +3 | awk '{print $1}' | grep libgeos_c`
if [[ ${var_shit:0:1} == *"/"* ]]; then
install_name_tool -change ${var_shit} libgeos_c_hide.dylib  liblwgeom-2.1.5.dylib
fi

var_shit=`otool -L liblwgeom-2.1.5.dylib | tail -n +3 | awk '{print $1}' | grep libproj`
if [[ ${var_shit:0:1} == *"/"* ]]; then
install_name_tool -change ${var_shit} libproj_hide.dylib  liblwgeom-2.1.5.dylib
fi

var_shit=`otool -L liblwgeom-2.1.5.dylib | tail -n +3 | awk '{print $1}' | grep libjson-c`
if [[ ${var_shit:0:1} == *"/"* ]]; then
install_name_tool -change ${var_shit} libjson-c.dylib  liblwgeom-2.1.5.dylib
fi

var_shit=`otool -L liblwgeom-2.1.5.dylib | tail -n +3 | awk '{print $1}' | grep libproj`
if [[ ${var_shit:0:1} == *"/"* ]]; then
install_name_tool -change ${var_shit} libproj_hide.dylib  liblwgeom-2.1.5.dylib
fi

mv liblwgeom-2.1.5.dylib liblwgeom-2.dylib


cp -f ${lib_loc}/libfftw3f_threads.3.dylib .
chmod +w libfftw3f_threads.3.dylib
install_name_tool -id libfftw3f_threads.dylib libfftw3f_threads.3.dylib

var_shit=`otool -L libfftw3f_threads.3.dylib | tail -n +3 | awk '{print $1}' | grep libfftw3f.3`
if [[ ${var_shit:0:1} == *"/"* ]]; then
install_name_tool -change ${var_shit} libfftw3f.dylib libfftw3f_threads.3.dylib 
fi
mv libfftw3f_threads.3.dylib libfftw3f_threads.dylib


cp -f ${lib_loc}/libepsilon.1.dylib .
chmod +w libepsilon.1.dylib
install_name_tool -id libepsilon.dylib     libepsilon.1.dylib

var_shit=`otool -L libepsilon.1.dylib | tail -n +3 | awk '{print $1}' | grep libpopt`
if [[ ${var_shit:0:1} == *"/"* ]]; then
install_name_tool -change ${var_shit} libpopt.dylib libepsilon.1.dylib 
fi
mv libepsilon.1.dylib libepsilon.dylib


cp /usr/local/lib/libxerces-c-3.1.dylib .
chmod +w libxerces-c-3.1.dylib
install_name_tool -id libxerces-c.dylib    libxerces-c-3.1.dylib

var_shit=`otool -L libxerces-c-3.1.dylib | tail -n +3 | awk '{print $1}' | grep libxerces-c-3`
if [[ ${var_shit:0:1} == *"/"* ]]; then
install_name_tool -change ${var_shit} libxerces-c.dylib libxerces-c-3.1.dylib
fi
mv libxerces-c-3.1.dylib libxerces-c.dylib


cp -f /usr/local/opt/openssl/lib/libcrypto.1.0.0.dylib .
chmod +w libcrypto.1.0.0.dylib
install_name_tool -id libcrypto.dylib  libcrypto.1.0.0.dylib

var_shit=`otool -L libcrypto.1.0.0.dylib | tail -n +3 | awk '{print $1}' | grep libcrypto`
if [[ ${var_shit:0:1} == *"/"* ]]; then
install_name_tool -change ${var_shit} libcrypto.dylib libcrypto.1.0.0.dylib
fi
mv libcrypto.1.0.0.dylib libcrypto.dylib


# ------------------ OpenCVs
patoCV=/usr/local/Cellar/opencv/2.4.12_2/lib
install_name_tool -id libopencv_core.dylib     libopencv_core.2.4.dylib
install_name_tool -change /usr/local/lib/libopencv_core.2.4.dylib  libopencv_core.dylib libopencv_core.dylib

install_name_tool -id libopencv_imgproc.dylib  libopencv_imgproc.2.4.dylib
install_name_tool -change ${patoCV}/libopencv_imgproc.2.4.dylib    ibopencv_imgproc.dylib     libopencv_imgproc.dylib
install_name_tool -change ${patoCV}/libopencv_core.2.4.dylib       libopencv_core.dylib       libopencv_imgproc.dylib

install_name_tool -id libopencv_objdetect.dylib libopencv_objdetect.2.4.dylib
install_name_tool -change ${patoCV}/libopencv_objdetect.2.4.dylib  libopencv_objdetect.dylib  libopencv_objdetect.dylib
install_name_tool -change ${patoCV}/libopencv_core.2.4.dylib       libopencv_core.dylib       libopencv_objdetect.dylib
install_name_tool -change ${patoCV}/libopencv_imgproc.2.4.dylib    libopencv_imgproc.dylib    libopencv_objdetect.dylib
install_name_tool -change ${patoCV}/libopencv_highgui.2.4.dylib    libopencv_highgui.dylib    libopencv_objdetect.dylib
install_name_tool -change ${patoCV}/libopencv_features2d.2.4.dylib libopencv_features2d.dylib libopencv_objdetect.dylib
install_name_tool -change ${patoCV}/libopencv_calib3d.2.4.dylib    libopencv_calib3d.dylib    libopencv_objdetect.dylib
install_name_tool -change ${patoCV}/libopencv_flann.2.4.dylib      libopencv_flann.dylib      libopencv_objdetect.dylib

install_name_tool -id libopencv_calib3d.dylib   libopencv_calib3d.2.4.dylib
install_name_tool -change ${patoCV}/libopencv_calib3d.2.4.dylib libopencv_calib3d.dylib libopencv_calib3d.dylib
install_name_tool -change ${patoCV}/libopencv_core.2.4.dylib libopencv_core.dylib       libopencv_calib3d.dylib
install_name_tool -change ${patoCV}/libopencv_imgproc.2.4.dylib libopencv_imgproc.dylib libopencv_calib3d.dylib
install_name_tool -change ${patoCV}/libopencv_highgui.2.4.dylib libopencv_highgui.dylib libopencv_calib3d.dylib
install_name_tool -change ${patoCV}/libopencv_features2d.2.4.dylib libopencv_features2d.dylib libopencv_calib3d.dylib
install_name_tool -change ${patoCV}/libopencv_flann.2.4.dylib libopencv_flann.dylib     libopencv_calib3d.dylib

install_name_tool -id libopencv_video.dylib     libopencv_video.2.4.dylib
install_name_tool -change ${patoCV}/libopencv_video.2.4.dylib   libopencv_video.dylib   libopencv_video.dylib
install_name_tool -change ${patoCV}/libopencv_core.2.4.dylib    libopencv_core.dylib    libopencv_video.dylib
install_name_tool -change ${patoCV}/libopencv_imgproc.2.4.dylib libopencv_imgproc.dylib libopencv_video.dylib

install_name_tool -id libopencv_highgui.dylib    libopencv_highgui.2.4.dylib
install_name_tool -change ${patoCV}/libopencv_highgui.2.4.dylib  libopencv_highgui.dylib    libopencv_highgui.dylib
install_name_tool -change ${patoCV}/libopencv_core.2.4.dylib     libopencv_core.dylib       libopencv_highgui.dylib
install_name_tool -change ${patoCV}/libopencv_imgproc.2.4.dylib  libopencv_imgproc.dylib    libopencv_highgui.dylib
install_name_tool -change /usr/local/opt/ilmbase/lib/libImath-2_2.12.dylib        libImath-2_2.dylib         libopencv_highgui.dylib
install_name_tool -change /usr/local/opt/openexr/lib/libIlmImf-2_2.22.dylib       libIlmImf-2_2.dylib        libopencv_highgui.dylib
install_name_tool -change /usr/local/opt/ilmbase/lib/libIex-2_2.12.dylib          libIex-2_2.dylib           libopencv_highgui.dylib
install_name_tool -change /usr/local/opt/ilmbase/lib/libHalf.12.dylib             libHalf-2_2.dylib          libopencv_highgui.dylib
install_name_tool -change /usr/local/opt/ilmbase/lib/libIlmThread-2_2.12.dylib    libIlmThread-2_2.dylib     libopencv_highgui.dylib

install_name_tool -id libopencv_features2d.dylib  libopencv_features2d.2.4.dylib
install_name_tool -change ${patoCV}/libopencv_features2d.2.4.dylib  libopencv_features2d.dylib  libopencv_features2d.dylib
install_name_tool -change ${patoCV}/libopencv_core.2.4.dylib        libopencv_core.dylib        libopencv_features2d.dylib
install_name_tool -change ${patoCV}/libopencv_imgproc.2.4.dylib     libopencv_imgproc.dylib     libopencv_features2d.dylib
install_name_tool -change ${patoCV}/libopencv_highgui.2.4.dylib     libopencv_highgui.dylib     libopencv_features2d.dylib
install_name_tool -change ${patoCV}/libopencv_flann.2.4.dylib       libopencv_flann.dylib       libopencv_features2d.dylib

install_name_tool -id libopencv_flann.dylib  libopencv_flann.2.4.dylib
install_name_tool -change ${patoCV}/libopencv_flann.2.4.dylib  libopencv_flann.dylib  libopencv_flann.dylib
install_name_tool -change ${patoCV}/libopencv_core.2.4.dylib   libopencv_core.dylib   libopencv_flann.dylib

install_name_tool -id libopencv_photo.dylib  libopencv_photo.2.4.dylib

install_name_tool -change ${patoCV}/libopencv_imgproc.2.4.dylib libopencv_imgproc.dylib libopencv_highgui.dylib
install_name_tool -change /usr/local/opt/jpeg/lib/libjpeg.8.dylib libjpeg.dylib libopencv_highgui.dylib
install_name_tool -change /usr/local/opt/libpng/lib/libpng16.16.dylib libpng16.16.dylib libopencv_highgui.dylib
install_name_tool -change /usr/local/opt/libtiff/lib/libtiff.5.dylib libtiff.5.dylib libopencv_highgui.dylib
install_name_tool -change ${patoCV}/libopencv_core.2.4.dylib libopencv_core.dylib libopencv_highgui.dylib

install_name_tool -change ${patoCV}/libopencv_features2d.2.4.dylib libopencv_features2d.dylib libopencv_calib3d.dylib
install_name_tool -change ${patoCV}/libopencv_flann.2.4.dylib libopencv_flann.dylib libopencv_calib3d.dylib
install_name_tool -change ${patoCV}/libopencv_highgui.2.4.dylib libopencv_highgui.dylib libopencv_calib3d.dylib
install_name_tool -change ${patoCV}/libopencv_imgproc.2.4.dylib libopencv_imgproc.dylib libopencv_calib3d.dylib
install_name_tool -change ${patoCV}/libopencv_core.2.4.dylib libopencv_core.dylib libopencv_calib3d.dylib

install_name_tool -change ${patoCV}/libopencv_flann.2.4.dylib libopencv_flann.dylib libopencv_features2d.dylib
install_name_tool -change ${patoCV}/libopencv_highgui.2.4.dylib libopencv_highgui.dylib libopencv_features2d.dylib
install_name_tool -change ${patoCV}/libopencv_imgproc.2.4.dylib libopencv_imgproc.dylib libopencv_features2d.dylib
install_name_tool -change ${patoCV}/libopencv_core.2.4.dylib libopencv_core.dylib libopencv_features2d.dylib

install_name_tool -change ${patoCV}/libopencv_core.2.4.dylib libopencv_core.dylib libopencv_flann.dylib

install_name_tool -change ${patoCV}/libopencv_core.2.4.dylib libopencv_core.dylib libopencv_imgproc.dylib

install_name_tool -change ${patoCV}/libopencv_highgui.2.4.dylib libopencv_highgui.dylib libopencv_objdetect.dylib
install_name_tool -change ${patoCV}/libopencv_imgproc.2.4.dylib libopencv_imgproc.dylib libopencv_objdetect.dylib
install_name_tool -change ${patoCV}/libopencv_core.2.4.dylib libopencv_core.dylib libopencv_objdetect.dylib

install_name_tool -change ${patoCV}/libopencv_imgproc.2.4.dylib libopencv_imgproc.dylib libopencv_photo.dylib
install_name_tool -change ${patoCV}/libopencv_core.2.4.dylib libopencv_core.dylib libopencv_photo.dylib

install_name_tool -change ${patoCV}/libopencv_imgproc.2.4.dylib libopencv_imgproc.dylib libopencv_video.dylib
install_name_tool -change ${patoCV}/libopencv_core.2.4.dylib libopencv_core.dylib libopencv_video.dylib

install_name_tool -change /usr/local/Cellar/ilmbase/2.2.0/lib/libIex-2_2.12.dylib libIex-2_2.dylib libImath-2_2.dylib

install_name_tool -change /usr/local/lib/libImath-2_2.12.dylib     libImath-2_2.dylib     libIlmImf-2_2.dylib
install_name_tool -change /usr/local/lib/libHalf.12.dylib          libHalf.dylib          libIlmImf-2_2.dylib
install_name_tool -change /usr/local/lib/libIex-2_2.12.dylib       libIex-2_2.dylib       libIlmImf-2_2.dylib
install_name_tool -change /usr/local/lib/libIexMath-2_2.12.dylib   libIexMath-2_2.dylib   libIlmImf-2_2.dylib
install_name_tool -change /usr/local/lib/libIlmThread-2_2.12.dylib libIlmThread-2_2.dylib libIlmImf-2_2.dylib

install_name_tool -change /usr/local/Cellar/ilmbase/2.2.0/lib/libIex-2_2.12.dylib libIex-2_2.dylib libIlmThread-2_2.dylib





