import os
def inplace_change(filename, old_string, new_string):
    # Safely read the input filename using 'with'
    with open(filename) as f:
        s = f.read()
        if old_string not in s:
            print ('"{old_string}" not found in {filename}.'.format(**locals()))
            return

    # Safely write the changed content, if found in the file
    with open(filename, 'w') as f:
        print ('Changing "{old_string}" to "{new_string}" in {filename}'.format(**locals()))
        s = s.replace(old_string, new_string)
        f.write(s)
file_name = '/home/tuyet/Git/shell/test.txt'
file_new = open('/home/tuyet/Git/shell/name_ID.txt', 'r')

replaces = file_new.read().splitlines()

file_old = open(file_name, 'r')
contents = file_old.read().splitlines()

for content in contents:
    content_values = content.split('=')
    name = content_values[0]
    id = content_values[1]

    for replace in replaces:

        replace_values = replace.split('=')
        name_replace = replace_values[0]
        # print(name_replace)
        id_replace = replace_values[1]
        # print(id_replace)

        if ((name == name_replace) and (id != id_replace)):
            inplace_change(file_name, content, replace)

        with open(file_name, "r+") as f:
            line_found = any(replace in line for line in f)
            if not line_found:
                f.seek(0, os.SEEK_END)
                f.write("{}\n".format(replace))



