/**
 * simpleRenamer
 *
 * Written by Karsten-Kai König
 *
 * Copyright (C) 2010-2011 Karsten-Kai König <KKoenig@posteo.de>
 * 
 * This program is free software; you can redistribute it and/or modify it 
 * under the terms of the GNU General Public License as published by the Free 
 * Software Foundation; either version 3 of the License, or (at your option) 
 * any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT 
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or 
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for 
 * more details.
 *
 * You should have received a copy of the GNU General Public License along with 
 * this program; if not, see <http://www.gnu.org/licenses/>.
 */

using GLib;
using Gee;

class App : Object {
    /* Fields for parsing commandline options */
    private static string pre = "";
    private static string post = "";
    private static string filename;
    private static bool interactive;
    private static bool conserve;
    private static int start;
    private static const OptionEntry[] entries = {
        { "pre", 0, 0, OptionArg.STRING, ref pre, "set prefix that will be placed to the left of the number", "PREFIX" },
        { "post", 0, 0, OptionArg.STRING, ref post, "set postfix that will be placed to the left of the number", "POSTFIX" },
        { "list", 'l', 0, OptionArg.FILENAME, ref filename, "use a list of files instead of all files in the directory", "LIST" },
        { "interactive", 'i', 0, OptionArg.NONE, ref interactive, "choose which files should be renamed interactive", null },
        { "conserve", 'c', 0, OptionArg.NONE, ref conserve, "conserve file extension", null },
        { "start", 's', 0, OptionArg.INT, ref start, "set startnumber", "START" },
        { null }
    };

    /* Field to access the directory which contains the files to rename */
    private static Dir dir;

    /* Field which containts the files to rename */
    private static ArrayList<string> files;


    /* Method to parse the commandline */
    protected void parse_commandline_options(string[] args) {
        var opt_context = new OptionContext("<DIRECTORY>");

        opt_context.set_help_enabled(true);
        opt_context.add_main_entries(this.entries, null);

        try {
            opt_context.parse(ref args);
            if(args.length >= 2) {
                dir = Dir.open(args[args.length-1]);
            }
            else if(args.length < 2) {
                throw new FileError.FAULT("Need at least a path to a directory");
            }
        }
        catch(OptionError error) {
            stderr.printf("\n%s\n\n", error.message);
            stderr.printf("%s", opt_context.get_help(true, null));
            Process.exit(1);
        }
        catch(FileError error) {
            stderr.printf("\n%s\n\n", error.message);
            stderr.printf("%s", opt_context.get_help(true, null));
            Process.exit(1);
        }
    }

    /* Method to fill the array files */
    protected void get_files() {
        string file = "";
        this.files = new ArrayList<string>();

        do {
            file = dir.read_name();
            this.files.add(file);
        } while(file != null);

        /* Cut "null" which was only needed to terminate the loop */
        this.files.remove_at(this.files.size-1);
        this.files.sort((CompareFunc) strcmp);
    }

    /* Method to rename the files */
    protected void rename_files() {
        int counter = 1;
        string answer;

        foreach(string s in files) {
            if(interactive) {
                stdout.printf("Rename %s to %s%s%s? [Y/n]", s, this.pre, counter.to_string(), this.post);
                answer = stdin.read_line();
                if(answer != "n") {
                    stdout.printf("Rename %s to %s%s%s\n", s, this.pre, counter.to_string(), this.post);
                    FileUtils.rename(s, pre+counter.to_string()+post);
                    counter++;
                }
            }
            else {
                stdout.printf("Rename %s to %s%s%s\n", s, this.pre, counter.to_string(), this.post);
                FileUtils.rename(s, pre+counter.to_string()+post);
                counter++;
            }
        }
    }

    /** Main loop
      * 1. Parse commandline
      * 2. Get the paths of the files in the aiming directory
      * 3. Move into this directory
      * 4. Rename the files
      */
    public void run(string[] args) {
        this.parse_commandline_options(args);
        this.get_files();
        Environment.set_current_dir(args[args.length-1]);
        rename_files();
    }


    /* Start the main loop */
    static int main(string[] args) {
        var app = new App();
        app.run(args);

        return 0;
    }
}

