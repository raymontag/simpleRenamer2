/**
 * simpleRenamer
 *
 * Written by Karsten-Kai König
 *
 * Copyright (C) 2010-2011 Karsten-Kai König <KKoenig@posteo.de>
 * 
 * This program is free software; you can redistribute it and/or modify it under 
 * the terms of the GNU General Public License as published by the Free Software 
 * Foundation; either version 3 of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT 
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS 
 * FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License along with 
 * this program; if not, see <http://www.gnu.org/licenses/>.
 */

string pre;
string post;
string filename;
bool interactive;
bool conserve;
int start;

const OptionEntry[] entries = {
    { "pre", 0, 0, OptionArg.STRING, ref pre, "set prefix that will be placed to the left of the number", "PREFIX" }, 
    { "post", 0, 0, OptionArg.STRING, ref post, "set postfix that will be placed to the left of the number", "POSTFIX" }, 
    { "list", 'l', 0, OptionArg.FILENAME, ref filename, "use a list of files instead of all files in the directory", "LIST" }, 
    { "interactive", 'i', 0, OptionArg.NONE, ref interactive, "choose which files should be renamed interactive", null }, 
    { "conserve", 'c', 0, OptionArg.NONE, ref conserve, "conserve file extension", null }, 
    { "start", 's', 0, OptionArg.INT, ref start, "set startnumber", "START" },
    { null }
};

class App : Object {
	protected void parse_commandline_options(string[] args) {
		var opt_context = new OptionContext("<DIRECTORY>");

        opt_context.set_help_enabled(true);
        opt_context.add_main_entries(entries, null);

        try {
            opt_context.parse(ref args);
        }
        catch(OptionError error) {
            stdout.printf("\n%s\n\n", error.message);
			stdout.printf("%s", opt_context.get_help(true, null));
        }
	}
    public void run(string[] args) {
		this.parse_commandline_options(args);
    }

    static int main(string[] args) {
        var app = new App();
        app.run(args);

        return 0;
    }
}


