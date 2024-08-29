import intersection from "lodash.intersection";

class ArraysUtils {
  /**
   *  Return true if left array is equals to right array
   * @param {Array} left
   * @param {Array} right
   * @returns {boolean}
   */
  static equals(left, right) {
    if (left.length !== right.length) {
      return false;
    }
    const intersectionList = intersection(left, right);
    return intersectionList.length === left.length;
  }

  /**
   *  Return array with index element in the new index position
   * @param {Array} arr
   * @param {number} fromIndex
   * @param {number} toIndex
   * @returns {Array}
   */
  static arrayMove = (arr, fromIndex, toIndex) => {
    var element = arr[fromIndex];
    arr.splice(fromIndex, 1);
    arr.splice(toIndex, 0, element);
    return arr;
  };
}

export default ArraysUtils;
