using NUnit.Framework;
using CN.Project.Domain.Extensions;

namespace CN.Project.Test
{
    [TestFixture]
    internal class ListExtensionsTest
    {
        [SetUp]
        public void Setup()
        {
        }

        #region Test

        [Test]
        public async Task OrderList_Success()
        {
            #region Arrange
            var people = new List<Person>
            {
                new Person { Id =1, FirstName = "Alice", LastName = "Johnson", Age = 25 },
                new Person { Id= 2, FirstName = "Bob", LastName = "Smith", Age = 22 },
                new Person { Id= 3,FirstName = "Alice", LastName = "Smith", Age = 28 },
                new Person { Id= 4,FirstName = "Charlie", LastName = "Brown", Age = 22 }
            };

            var sortBy = new List<string> { "LastName", "FirstName", "Age" };
            #endregion

            #region Act
            var ordererList = await Task.FromResult(people.SortBy(sortBy));
            #endregion

            #region Assert

            Assert.IsNotNull(ordererList);
            Assert.IsTrue(ordererList.Count == 4);
            Assert.IsTrue(ordererList[0].Id == 2);
            Assert.IsTrue(ordererList[1].Id == 4);
            Assert.IsTrue(ordererList[2].Id == 1);
            Assert.IsTrue(ordererList[3].Id == 3);

            #endregion
        }

        #endregion

        #region Private class
        private class Person
        {
            public int Id { get; set; }
            public string FirstName { get; set; } = string.Empty;
            public string LastName { get; set; } = string.Empty;
            public int Age { get; set; }
        }
        #endregion

    }
}
