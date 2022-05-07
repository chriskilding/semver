Name:           semver
Version:        0.0.10
Release:        %autorelease
Summary:        Semantic Versioning utility
BuildArch:      noarch
License:        MIT
URL:            https://github.com/chriskilding/%{name}
Source0:        https://github.com/chriskilding/%{name}/archive/refs/tags/%{version}.tar.gz

Requires:       perl

%description
The %{name} utility is a text filter for Semantic Version strings. It searches text from the standard input, selects any Semantic Versions that are present, and writes them to the standard output. It can optionally sort or tabulate the selected versions.

%prep
%setup -q

%build
make

%install
rm -rf $RPM_BUILD_ROOT
mkdir -p $RPM_BUILD_ROOT%{_bindir}
mkdir -p $RPM_BUILD_ROOT%{_mandir}/man1/
cp %{name} $RPM_BUILD_ROOT%{_bindir}
cp %{name}.1 $RPM_BUILD_ROOT%{_mandir}/man1/

%files
%{_bindir}/%{name}
%{_mandir}/man1/%{name}.1.gz
%doc README.md
%license LICENSE

%changelog
%autochangelog
