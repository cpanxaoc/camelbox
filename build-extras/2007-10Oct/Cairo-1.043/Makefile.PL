#
# Copyright (c) 2004-2006 by the cairo perl team (see the file README)
#
# Licensed under the LGPL, see LICENSE file for more information.
#
# $Header: /cvs/cairo/cairo-perl/Makefile.PL,v 1.28 2007-10-13 21:23:16 tsch Exp $
#

BEGIN { require 5.006; }

use strict;
use warnings;
use ExtUtils::MakeMaker;
use MakeHelper;

my %extreqs = (
	'cairo' => '1.0.0',
);

# Unfortunately we already need these prereqs for writing the Makefile ...
my %prereqs = (
	'ExtUtils::Depends'   => 0.2,
	'ExtUtils::PkgConfig' => 1.0,
);

# ... thus we have to make sure they are installed.
while ((my $module, my $version) = each(%prereqs)) {
	unless (eval "use $module $version; 1" ) {
		print "This module requires $module to install itself.\n";
		my $yn = ExtUtils::MakeMaker::prompt("  Install $module from CPAN?", 'y');

		unless ($yn =~ /^y/i) {
			die " *** Cannot install without $module.  Exiting ...\n";
		}

		require Cwd;
		require File::Spec;
		require CPAN;

		# Save this 'cause CPAN will chdir all over the place.
		my $cwd = Cwd::cwd();
		my $makefile = File::Spec->rel2abs($0);

		CPAN::Shell->install($module);

		chdir $cwd
			or die "Cannot chdir() back to $cwd: $!";
	}
	eval "use $module $version; 1" or die $@;
}

# Add this now since it's not required to generate a Makefile.
$prereqs{'Test::Number::Delta'} = 1.00;

my $autogen_dir = 'build';
mkdir $autogen_dir unless (-d $autogen_dir);
$MakeHelper::autogen_dir = $autogen_dir;

my %cairo_cfg = ExtUtils::PkgConfig->find ("cairo >= $extreqs{cairo}");

my %backend_guards = (
	'cairo_pdf_surface_t' => 'CAIRO_HAS_PDF_SURFACE',
	'cairo_ps_surface_t'  => 'CAIRO_HAS_PS_SURFACE',
	'cairo_svg_surface_t' => 'CAIRO_HAS_SVG_SURFACE',
);

my %objects = (
	'cairo_t *'             => 'Cairo::Context',
	'cairo_font_face_t *'   => 'Cairo::FontFace',
	'cairo_pattern_t *'     => 'Cairo::Pattern',
	'cairo_scaled_font_t *' => 'Cairo::ScaledFont',
	'cairo_surface_t *'     => 'Cairo::Surface',
);

my %structs = (
	'cairo_font_options_t *' => 'Cairo::FontOptions',
	'cairo_matrix_t *'       => 'Cairo::Matrix',
);

my %enums = (
	cairo_antialias_t => [qw/
		CAIRO_ANTIALIAS_
		CAIRO_ANTIALIAS_DEFAULT
		CAIRO_ANTIALIAS_NONE
		CAIRO_ANTIALIAS_GRAY
		CAIRO_ANTIALIAS_SUBPIXEL
	/],
	cairo_content_t => [qw/
		CAIRO_CONTENT_
		CAIRO_CONTENT_COLOR
		CAIRO_CONTENT_ALPHA
		CAIRO_CONTENT_COLOR_ALPHA
	/],
	cairo_extend_t => [qw/
		CAIRO_EXTEND_
		CAIRO_EXTEND_NONE
		CAIRO_EXTEND_REPEAT
		CAIRO_EXTEND_REFLECT
	/],
	cairo_fill_rule_t => [qw/
		CAIRO_FILL_RULE_
		CAIRO_FILL_RULE_WINDING
		CAIRO_FILL_RULE_EVEN_ODD
	/],
	cairo_filter_t => [qw/
		CAIRO_FILTER_
		CAIRO_FILTER_FAST
		CAIRO_FILTER_GOOD
		CAIRO_FILTER_BEST
		CAIRO_FILTER_NEAREST
		CAIRO_FILTER_BILINEAR
		CAIRO_FILTER_GAUSSIAN
	/],
	cairo_font_slant_t => [qw/
		CAIRO_FONT_SLANT_
		CAIRO_FONT_SLANT_NORMAL
		CAIRO_FONT_SLANT_ITALIC
		CAIRO_FONT_SLANT_OBLIQUE
	/],
	cairo_font_weight_t => [qw/
		CAIRO_FONT_WEIGHT_
		CAIRO_FONT_WEIGHT_NORMAL
		CAIRO_FONT_WEIGHT_BOLD
	/],
	cairo_format_t => [qw/
		CAIRO_FORMAT_
		CAIRO_FORMAT_ARGB32
		CAIRO_FORMAT_RGB24
		CAIRO_FORMAT_A8
		CAIRO_FORMAT_A1
	/],
	cairo_hint_metrics_t => [qw/
		CAIRO_HINT_METRICS_
		CAIRO_HINT_METRICS_DEFAULT
		CAIRO_HINT_METRICS_OFF
		CAIRO_HINT_METRICS_ON
	/],
	cairo_hint_style_t => [qw/
		CAIRO_HINT_STYLE_
		CAIRO_HINT_STYLE_DEFAULT
		CAIRO_HINT_STYLE_NONE
		CAIRO_HINT_STYLE_SLIGHT
		CAIRO_HINT_STYLE_MEDIUM
		CAIRO_HINT_STYLE_FULL
	/],
	cairo_line_cap_t => [qw/
		CAIRO_LINE_CAP_
		CAIRO_LINE_CAP_BUTT
		CAIRO_LINE_CAP_ROUND
		CAIRO_LINE_CAP_SQUARE
	/],
	cairo_line_join_t => [qw/
		CAIRO_LINE_JOIN_
		CAIRO_LINE_JOIN_MITER
		CAIRO_LINE_JOIN_ROUND
		CAIRO_LINE_JOIN_BEVEL
	/],
	cairo_operator_t => [qw/
		CAIRO_OPERATOR_
		CAIRO_OPERATOR_CLEAR
		CAIRO_OPERATOR_SOURCE
		CAIRO_OPERATOR_OVER
		CAIRO_OPERATOR_IN
		CAIRO_OPERATOR_OUT
		CAIRO_OPERATOR_ATOP
		CAIRO_OPERATOR_DEST
		CAIRO_OPERATOR_DEST_OVER
		CAIRO_OPERATOR_DEST_IN
		CAIRO_OPERATOR_DEST_OUT
		CAIRO_OPERATOR_DEST_ATOP
		CAIRO_OPERATOR_XOR
		CAIRO_OPERATOR_ADD
		CAIRO_OPERATOR_SATURATE
	/],
	cairo_path_data_type_t => [qw/
		CAIRO_PATH_
		CAIRO_PATH_MOVE_TO
		CAIRO_PATH_LINE_TO
		CAIRO_PATH_CURVE_TO
		CAIRO_PATH_CLOSE_PATH
	/],
	cairo_status_t => [qw/
		CAIRO_STATUS_
		CAIRO_STATUS_SUCCESS
		CAIRO_STATUS_NO_MEMORY
		CAIRO_STATUS_INVALID_RESTORE
		CAIRO_STATUS_INVALID_POP_GROUP
		CAIRO_STATUS_NO_CURRENT_POINT
		CAIRO_STATUS_INVALID_MATRIX
		CAIRO_STATUS_INVALID_STATUS
		CAIRO_STATUS_NULL_POINTER
		CAIRO_STATUS_INVALID_STRING
		CAIRO_STATUS_INVALID_PATH_DATA
		CAIRO_STATUS_READ_ERROR
		CAIRO_STATUS_WRITE_ERROR
		CAIRO_STATUS_SURFACE_FINISHED
		CAIRO_STATUS_SURFACE_TYPE_MISMATCH
		CAIRO_STATUS_PATTERN_TYPE_MISMATCH
		CAIRO_STATUS_INVALID_CONTENT
		CAIRO_STATUS_INVALID_FORMAT
		CAIRO_STATUS_INVALID_VISUAL
		CAIRO_STATUS_FILE_NOT_FOUND
		CAIRO_STATUS_INVALID_DASH
	/],
	cairo_subpixel_order_t => [qw/
		CAIRO_SUBPIXEL_ORDER_
		CAIRO_SUBPIXEL_ORDER_DEFAULT
		CAIRO_SUBPIXEL_ORDER_RGB
		CAIRO_SUBPIXEL_ORDER_BGR
		CAIRO_SUBPIXEL_ORDER_VRGB
		CAIRO_SUBPIXEL_ORDER_VBGR
	/],
);

# --------------------------------------------------------------------------- #

my $have_cairo_1_2 = ExtUtils::PkgConfig->atleast_version("cairo", "1.2.0");
my $have_cairo_1_4 = ExtUtils::PkgConfig->atleast_version("cairo", "1.4.0");

if ($have_cairo_1_2) {
	my %new = (
		cairo_extend_t => [qw/CAIRO_EXTEND_PAD/],
		cairo_format_t => [qw/CAIRO_FORMAT_RGB16_565/],
		cairo_status_t => [qw/CAIRO_STATUS_INVALID_DSC_COMMENT/],
	);

	foreach my $enum (keys %new) {
		foreach my $value (@{$new{$enum}}) {
			push @{$enums{$enum}}, $value;
		}
	}

	$enums{cairo_font_type_t} = [qw/
		CAIRO_FONT_TYPE_
		CAIRO_FONT_TYPE_TOY
		CAIRO_FONT_TYPE_FT
		CAIRO_FONT_TYPE_WIN32
		CAIRO_FONT_TYPE_ATSUI
	/];

	$enums{cairo_pattern_type_t} = [qw/
		CAIRO_PATTERN_TYPE_
		CAIRO_PATTERN_TYPE_SOLID
		CAIRO_PATTERN_TYPE_SURFACE
		CAIRO_PATTERN_TYPE_LINEAR
		CAIRO_PATTERN_TYPE_RADIAL
	/];

	$enums{cairo_surface_type_t} = [qw/
		CAIRO_SURFACE_TYPE_
		CAIRO_SURFACE_TYPE_IMAGE
		CAIRO_SURFACE_TYPE_PDF
		CAIRO_SURFACE_TYPE_PS
		CAIRO_SURFACE_TYPE_XLIB
		CAIRO_SURFACE_TYPE_XCB
		CAIRO_SURFACE_TYPE_GLITZ
		CAIRO_SURFACE_TYPE_QUARTZ
		CAIRO_SURFACE_TYPE_WIN32
		CAIRO_SURFACE_TYPE_BEOS
		CAIRO_SURFACE_TYPE_DIRECTFB
		CAIRO_SURFACE_TYPE_SVG
	/];

	$enums{cairo_svg_version_t} = [qw/
		CAIRO_SVG_VERSION_
		CAIRO_SVG_VERSION_1_1
		CAIRO_SVG_VERSION_1_2
	/];
} else {
	# We need to create empty enum entries for new types so that typemaps
	# are generated for them.  xsubpp demands typemaps even if the code is
	# #if'd out.
	$enums{cairo_font_type_t} = [];
	$enums{cairo_pattern_type_t} = [];
	$enums{cairo_surface_type_t} = [];
	$enums{cairo_svg_version_t} = [];
}

if ($have_cairo_1_4) {
	my %new = (
		cairo_status_t => [qw/CAIRO_STATUS_INVALID_INDEX
		                      CAIRO_STATUS_CLIP_NOT_REPRESENTABLE/],
	);

	foreach my $enum (keys %new) {
		foreach my $value (@{$new{$enum}}) {
			push @{$enums{$enum}}, $value;
		}
	}
}

# --------------------------------------------------------------------------- #

my %enum_guards = (
	cairo_svg_version_t => $backend_guards{cairo_svg_surface_t},
);

MakeHelper::do_enums (\%enums, \%enum_guards);

my @xs_files = <*.xs>;

MakeHelper::write_boot (
	xs_files => \@xs_files,
	ignore => '^Cairo$',
);

my @typemaps = MakeHelper::do_typemaps (\%objects, \%structs, \%enums,
                                        \%backend_guards, \%enum_guards);
push @typemaps, 'cairo-perl.typemap';

my $dep = ExtUtils::Depends->new ('Cairo');
$dep->set_inc ('-I. -I'.$autogen_dir.' '.$cairo_cfg{cflags});
$dep->set_libs ($cairo_cfg{libs});
$dep->add_xs (@xs_files);
$dep->add_c ('cairo-perl-enums.c');
$dep->add_pm ('Cairo.pm' => '$(INST_LIBDIR)/Cairo.pm');
$dep->add_typemaps (@typemaps);

$dep->install (qw(cairo-perl.h
                  cairo-perl.typemap
                  doctypes
                  build/cairo-perl-auto.h
                  build/cairo-perl-auto.typemap));
$dep->save_config ('build/IFiles.pm');

my @exports = qw(
    cairo_font_type_from_sv
    cairo_font_type_to_sv
	cairo_object_from_sv
	cairo_object_to_sv
	cairo_pattern_to_sv
	cairo_struct_from_sv
	cairo_struct_to_sv
	cairo_surface_to_sv
	newSVCairoFontExtents
	newSVCairoTextExtents
	newSVCairoGlyph
	SvCairoGlyph
	newSVCairoPath
	SvCairoPath

);

WriteMakefile (
	NAME          => 'Cairo',
	VERSION_FROM  => 'Cairo.pm',
	ABSTRACT_FROM => 'Cairo.pm',
	PREREQ_PM     => \%prereqs,
	XSPROTOARG    => '-noprototypes',
	FUNCLIST      => \@exports,
	DL_FUNCS      => { Cairo=> [] },

	$dep->get_makefile_vars,

	EXTRA_META => qq(
configure_requires:
    ExtUtils::Depends: $prereqs{'ExtUtils::Depends'}
    ExtUtils::PkgConfig: $prereqs{'ExtUtils::PkgConfig'}

build_requires:
    Test::Number::Delta: $prereqs{'Test::Number::Delta'}

no_index:
    file:
    - MakeHelper.pm
),
);

sub MY::postamble
{
	my $autogen_dir = $MakeHelper::autogen_dir;

	"realclean ::
	-\$(RM_RF) $autogen_dir cairo-perl-enums.*";
}
