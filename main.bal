import social_media.cache;
import ballerina/io;
import ballerina/lang.runtime;
import ballerina/persist;

public type UserWithPosts record {|
    string firstName;
    string lastName;
    string bio?;
    cache:Post[] posts;
|};

public function main() returns error? {
    // Initialize the client API
    cache:Client redisClient = check new();

    // Create user records
    cache:UserInsert user1 = {
        id: 1,
        email: "john.doe@gmail.com",
        firstName: "John",
        lastName: "Doe",
        gender: cache:MALE,
        dateOfBirth: {year: 2000, month: 8, day: 17},
        bio: "A passionate blogger and software engineer."
    };

    // Add users to the cache
    int[] userIds = check redisClient->/users.post([user1]);
    io:print("Created User Record Ids : ");
    io:println(userIds);

    // Create post records
    cache:PostInsert post1 = {
        id: 1,
        title: "Introduction to Redis Object Mapping",
        content: "Redis object mapping allows developers to...",
        userId: 1
    };

    // Add a post to the cache
    int[] postIds = check redisClient->/posts.post([post1]);
    io:print("Created Post Record Ids : ");
    io:println(postIds);

    // Get user details
    UserWithPosts user1WithPosts = check redisClient->/users/[1];
    io:print("Received user 1 with Posts : ");
    io:println(user1WithPosts);

    // Update a post
    cache:PostUpdate post1Update = {
        content: "Redis object mapping allows developers to easily integrate Redis with their applications, improving performance and scalability."
    };
    cache:Post post1Updated = check redisClient->/posts/[1].put(post1Update);
    io:print("Updated post : ");
    io:println(post1Updated);

    // Delete the post
    cache:Post post1Deleted = check redisClient->/posts/[1].delete();
    io:print("Deleted post : ");
    io:println(post1Deleted);

    // Get updated user details
    UserWithPosts user1WithPostsUpdated = check redisClient->/users/[1];
    io:print("Received user 1 with Posts : ");
    io:println(user1WithPostsUpdated);

    // Cache expires after 5 seconds
    runtime:sleep(5);

    // Get updated user details after the cache expires
    cache:User|persist:Error user1Updated = redisClient->/users/[1];
    io:println(user1Updated);
}
