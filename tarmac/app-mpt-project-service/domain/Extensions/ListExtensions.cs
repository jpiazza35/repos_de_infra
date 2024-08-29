using CN.Project.Domain.Dto;
using System.Reflection;

namespace CN.Project.Domain.Extensions
{
    public static class ListExtensions
    {

        /// <summary>
        /// Sorts the given list based on the values of the specified properties.
        /// </summary>
        /// <typeparam name="T">Type of the objects in the list</typeparam>
        /// <param name="list">List that will be sorted</param>
        /// <param name="sortBy">List of property names that will be used to sort</param>
        /// <returns>A new list sorted by the specified properties</returns>
        public static List<T> SortBy<T>(this List<T> list, List<string> sortBy)
        {
            List<T> sortedList = list;
            List<PropertyInfo> properties = GetProperties(typeof(T), sortBy);

            if (properties is not null && properties.Count > 0)
            {
                sortedList = (from item in list
                              orderby GenerateKey(item, properties)
                              select item).ToList();
            }

            return sortedList;
        }

        /// <summary>
        /// Gets the properties of the specified type that match the given names.
        /// </summary>
        /// <param name="type">Type from which to extract the properties</param>
        /// <param name="names">List of property names</param>
        /// <returns>List of PropertyInfo objects for the matching properties</returns>
        private static List<PropertyInfo> GetProperties(Type type, List<string> names)
        {
            List<PropertyInfo> properties = new List<PropertyInfo>();

            if (names is not null && names.Count > 0)
            {
                foreach (var name in names)
                {
                    var property = type.GetProperty(name);
                    if (property != null) properties.Add(property);
                }
            }
                
            return properties;
        }

        /// <summary>
        /// Generates a key for sorting based on the values of the specified properties of the given item.
        /// </summary>
        /// <param name="item">Item from which to read the values</param>
        /// <param name="properties">List of properties that must be read</param>
        /// <returns>A ComparerKey object encapsulating the values of the specified properties</returns>
        private static ComparerKey GenerateKey(object item, List<PropertyInfo> properties)
        {
            return new ComparerKey(properties.Select(p => p.GetValue(item)));
        }

        /// <summary>
        /// A comparison key that encapsulates the values of specific properties for sorting.
        /// </summary>
        private class ComparerKey : IComparable<ComparerKey>
        {
            private readonly object[] _values;

            public ComparerKey(IEnumerable<object> values)
            {
                _values = values.ToArray();
            }

            public int CompareTo(ComparerKey other)
            {
                int finalresult = 0;

                for (int i = 0; i < _values.Length; i++)
                {
                    int result = Comparer<object>.Default.Compare(_values[i], other._values[i]);
                    if (result != 0) finalresult = result;
                }

                return finalresult;
            }
        }
    }
}
