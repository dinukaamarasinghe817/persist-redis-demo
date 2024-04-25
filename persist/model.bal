import ballerina/persist as _;
import ballerina/time;

enum Gender {
    MALE,
    FEMALE
}

type User record {|
    readonly int id;
    string email;
    string firstName;
    string lastName;
    Gender gender;
    time:Date dateOfBirth;
    string bio?;
	Post[] posts;
|};

type Post record {|
    readonly int id;
    string title;
    string content;
    User user;
|};
