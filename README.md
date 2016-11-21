# Game Server

Here is the code repository of Game Server.

For Mac user, please check this [installation tutorial](https://github.com/Owlies/Owlies_Server/blob/master/mac_installation_instruction.md).

For Redhat user, please check this [installation tutorial](https://github.com/Owlies/Owlies_Server/blob/master/redhat_installation_instruction.md).

# Sproto:

For server:
 - Create a new .sproto, and put it into sproto_files/
 - Add the new .sproto to owlies_sproto_scheme.lua, add the YOUR_SPROTO_NAME to sprotoSchemeFiles table.
 - Use exanple:
    local sp = sprotoSchemes:getInstance().getScheme("YOUR_SPROTO_NAME");

    Decode:
    local addr = sp:decode("Person", msg, sz);

    Encode:
    local person = sp;
    person.name = "Huayu";
    person.id = 5000;
    person.phone = {number = "222222", type = 3};
    local code = sp:encode("Person", person);

For client:
 - install luarocks:
    https://github.com/luarocks/luarocks/wiki/Installation-instructions-for-Mac-OS-X
    follow the manual install instructions
    "configure", "make", "make install"

    then install lpeg:
    luarocks install lpeg
 - use: lua sprotodump.lua <option> <sproto_file1 sproto_file2 ...> [[<out_option> <outfile>] ...] [namespace_option]
   to generate .cs class from .sproto, and copy the generated file to Unity project Assets/Main/Sproto/

   useage exmaple:
    Encode:
    Person person = new Person ();
    person.name = "Alice";
    person.id = 10000;

    person.phone = new System.Collections.Generic.List<Person.PhoneNumber> ();
    Person.PhoneNumber num1 = new Person.PhoneNumber ();
    num1.number = "123456789";
    num1.type = 1;
    person.phone.Add (num1);

    byte[] person_data = person.encode();

    Decode:
    Person person = new Person (data);