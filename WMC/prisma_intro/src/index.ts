import { PrismaClient } from '@prisma/client';

const prisma = new PrismaClient();

async function main() {
  // 1. Create a new User
  const newUser = await prisma.user.create({
    data: {
      email: 'alice@example.com',
      name: 'Alice Smith',
    },
  });
  console.log('Created new user:', newUser);

  // 2. Create a Post for the new user
  const newPost = await prisma.post.create({
    data: {
      title: 'My First Post with Prisma',
      content: 'This is some content for my first post.',
      published: true,
      author: {
        connect: {
          id: newUser.id, // Connect the post to the newly created user
        },
      },
    },
  });
  console.log('Created new post:', newPost);

  // 3. Find all Users
  const allUsers = await prisma.user.findMany();
  console.log('\nAll users:');
  console.log(allUsers);

  // 4. Find Posts by a specific User
  const postsByUser = await prisma.post.findMany({
    where: {
      authorId: newUser.id,
    },
  });
  console.log(`\nPosts by ${newUser.name}:`);
  console.log(postsByUser);

  // 5. Find a User and include their Posts (Eager Loading)
  const userWithPosts = await prisma.user.findUnique({
    where: {
      id: newUser.id,
    },
    include: {
      posts: true, // Include related posts
    },
  });
  console.log('\nUser with posts:');
  console.log(userWithPosts);

  // 6. Update a User
  const updatedUser = await prisma.user.update({
    where: {
      id: newUser.id,
    },
    data: {
      name: 'Alice Johnson',
    },
  });
  console.log('\nUpdated user:', updatedUser);

  // 7. Delete a Post
  const deletedPost = await prisma.post.delete({
    where: {
      id: newPost.id,
    },
  });
  console.log('\nDeleted post:', deletedPost);

  // 8. Find all posts (expecting one less)
  const remainingPosts = await prisma.post.findMany();
  console.log('\nRemaining posts:', remainingPosts);
}

main()
  .catch((e) => {
    console.error(e);
  })
  .finally(async () => {
    await prisma.$disconnect(); // Close the database connection
  });
