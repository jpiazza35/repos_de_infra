// @ts-nocheck
/* eslint-disable */
import DOMPurify from "dompurify";

export const flatten = (obj, roots = [], sep = ".") =>
  Object
    // find props of given object
    .keys(obj)
    // return an object by iterating props
    .reduce(
      (memo, prop) =>
        Object.assign(
          // create a new object
          {},
          // include previously returned object
          memo,
          Object.prototype.toString.call(obj[prop]) === "[object Object]"
            ? // keep working if value is an object
              flatten(obj[prop], roots.concat([prop]), sep)
            : // include current prop and value and prefix prop with the roots
              { [roots.concat([prop]).join(sep)]: obj[prop] },
        ),
      {},
    );

export const isDirty = obj => {
  for (const key in obj) {
    const val = obj[key];
    if (val && typeof val === "object") {
      if (isDirty(val)) {
        return true;
      }
    } else if (val) {
      return true;
    }
  }
  return false;
};

export const promiseWrap = async promise =>
  // @ts-ignore
  Promise.allSettled([promise]).then(([{ value, reason }]) => {
    return [value?.data ? value?.data : value, reason];
  });

export const getDateString = date => {
  let d = date ? date : new Date();
  return `${String(d.getMonth() + 1).padStart(2, "0")}/${String(d.getDate()).padStart(2, "0")}/${d.getFullYear()}`;
};

export const formatDate = date => {
  const [year, month, day] = date.split("T")[0].split("-");
  return [month, day, year].join("/");
};

export const addHoursFromNow = hours => {
  const date = new Date();
  date.setTime(date.getTime() + hours * 60 * 60 * 1000);
  return date;
};

export const getParameterByName = (name, url = window.location.href) => {
  // name = name.replace(/[\[\]]/g, "\\$&");
  // @ts-ignore
  name = name.replace(/[[\]]/g, "\\$&");
  var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
    results = regex.exec(url);
  if (!results) return null;
  if (!results[2]) return "";
  return decodeURIComponent(results[2].replace(/\+/g, " "));
};

export const removeBlankColumns = data => {
  // Get an object with all properties and their values
  let allProps = data.reduce((acc, obj) => {
    Object.entries(obj).forEach(([prop, val]) => {
      if (!acc[prop]) {
        acc[prop] = [];
      }
      acc[prop].push(val);
    });
    return acc;
  }, {});

  // Filter out properties with falsy values in all objects
  let filteredProps = Object.entries(allProps)
    .filter(([_prop, vals]) => {
      return vals.every(val => !val);
    })
    .map(([prop]) => prop);

  // Remove filtered properties from each object in the array
  let result = data.map(obj => {
    filteredProps.forEach(prop => {
      delete obj[prop];
    });
    return obj;
  });

  return result;
};

export const filterNullProperties = array => {
  return array.map(obj => {
    return Object.keys(obj).reduce((filteredObj, key) => {
      if (obj[key] !== null) {
        filteredObj[key] = obj[key];
      }
      return filteredObj;
    }, {});
  });
};

export const sheetRowsToDataSourceData = array => {
  // Create an empty result array
  const result = [];

  // Iterate over each object in the input array
  for (let i = 1; i < array.length; i++) {
    const obj = array[i];
    const cells = obj.cells;

    // Create a new object to store the transformed values
    const transformedObj = {};

    // Iterate over each cell in the current object
    for (let j = 0; j < cells.length; j++) {
      const cell = cells[j];
      const key = array[0].cells[j].value; // Get the corresponding key from the first object
      const value = cell.value?.toString();

      // Store the transformed key-value pair in the new object
      transformedObj[key] = value;
    }

    // Add the transformed object to the result array
    result.push(transformedObj);
  }

  return result;
};

export function debounce(func, delay) {
  let timeoutId;
  return function (...args) {
    clearTimeout(timeoutId);
    timeoutId = setTimeout(() => func.apply(this, args), delay);
  };
}

import moment from "moment";

export function YEARFRAC(start_date, end_date, basis) {
  // Credits: David A. Wheeler [http://www.dwheeler.com/]

  // Initialize parameters
  var basis = typeof basis === "undefined" ? 0 : basis;
  var sdate = moment(new Date(start_date));
  var edate = moment(new Date(end_date));

  // Return error if either date is invalid
  if (!sdate.isValid() || !edate.isValid()) return "#VALUE!";

  // Return error if basis is neither 0, 1, 2, 3, or 4
  if ([0, 1, 2, 3, 4].indexOf(basis) === -1) return "#NUM!";

  // Return zero if start_date and end_date are the same
  if (sdate === edate) return 0;

  // Swap dates if start_date is later than end_date
  if (sdate.diff(edate) > 0) {
    var edate = moment(new Date(start_date));
    var sdate = moment(new Date(end_date));
  }

  // Lookup years, months, and days
  var syear = sdate.year();
  var smonth = sdate.month();
  var sday = sdate.date();
  var eyear = edate.year();
  var emonth = edate.month();
  var eday = edate.date();

  switch (basis) {
    case 0:
      // US (NASD) 30/360
      // Note: if eday == 31, it stays 31 if sday < 30
      if (sday === 31 && eday === 31) {
        sday = 30;
        eday = 30;
      } else if (sday === 31) {
        sday = 30;
      } else if (sday === 30 && eday === 31) {
        eday = 30;
      } else if (smonth === 1 && emonth === 1 && sdate.daysInMonth() === sday && edate.daysInMonth() === eday) {
        sday = 30;
        eday = 30;
      } else if (smonth === 1 && sdate.daysInMonth() === sday) {
        sday = 30;
      }
      return (eday + emonth * 30 + eyear * 360 - (sday + smonth * 30 + syear * 360)) / 360;
      break;

    case 1:
      // Actual/actual
      var feb29Between = function (date1, date2) {
        // Requires year2 == (year1 + 1) or year2 == year1
        // Returns TRUE if February 29 is between the two dates (date1 may be February 29), with two possibilities:
        // year1 is a leap year and date1 <= Februay 29 of year1
        // year2 is a leap year and date2 > Februay 29 of year2

        var mar1year1 = moment(new Date(date1.year(), 2, 1));
        if (moment([date1.year()]).isLeapYear() && date1.diff(mar1year1) < 0 && date2.diff(mar1year1) >= 0) {
          return true;
        }
        var mar1year2 = moment(new Date(date2.year(), 2, 1));
        if (moment([date2.year()]).isLeapYear() && date2.diff(mar1year2) >= 0 && date1.diff(mar1year2) < 0) {
          return true;
        }
        return false;
      };
      var ylength = 365;
      if (syear === eyear || (syear + 1 === eyear && (smonth > emonth || (smonth === emonth && sday >= eday)))) {
        if (syear === eyear && moment([syear]).isLeapYear()) {
          ylength = 366;
        } else if (feb29Between(sdate, edate) || (emonth === 1 && eday === 29)) {
          ylength = 366;
        }
        return edate.diff(sdate, "days") / ylength;
      } else {
        var years = eyear - syear + 1;
        var days = moment(new Date(eyear + 1, 0, 1)).diff(moment(new Date(syear, 0, 1)), "days");
        var average = days / years;
        return edate.diff(sdate, "days") / average;
      }
      break;

    case 2:
      // Actual/360
      return edate.diff(sdate, "days") / 360;
      break;

    case 3:
      // Actual/365
      return edate.diff(sdate, "days") / 365;
      break;

    case 4:
      // European 30/360
      if (sday === 31) sday = 30;
      if (eday === 31) eday = 30;
      // Remarkably, do NOT change February 28 or February 29 at ALL
      return (eday + emonth * 30 + eyear * 360 - (sday + smonth * 30 + syear * 360)) / 360;
      break;
  }
}

function lowerFirstLetter(inputString) {
  return inputString.charAt(0).toLowerCase() + inputString.slice(1);
}

export function lowerCamelCaseInObjectKeys(inputObject) {
  const outputObject = {};

  for (const key in inputObject) {
    if (inputObject.hasOwnProperty(key)) {
      const camelCaseKey = lowerFirstLetter(key);
      outputObject[camelCaseKey] = inputObject[key];
    }
  }

  return outputObject;
}

export function getKeysWithEmptyStringOrNull(objects) {
  // Create an object to store the keys and their occurrence counts
  const keyCounts = {};

  // Iterate over each object in the array
  objects.forEach(obj => {
    // Iterate over each key in the object
    Object.keys(obj).forEach(key => {
      // If the key has an empty string or null value, increment its count
      if (obj[key] === "" || obj[key] === null) {
        keyCounts[key] = (keyCounts[key] || 0) + 1;
      }
    });
  });

  // Filter keys that have a count equal to the number of objects
  const result = Object.keys(keyCounts).filter(key => keyCounts[key] === objects.length);

  return result;

  // Example of usage array of objects
  // const arrayOfObjects = [
  //   { key1: "", key2: null, key3: "", key4: null },
  //   { key1: "", key2: "", key3: null, key4: null },
  //   { key1: "value1", key2: "", key3: null, key4: "value4" },
  // ];

  // // Get keys with empty string or null for all objects in the array
  // const result = getKeysWithEmptyStringOrNull(arrayOfObjects);

  // console.log(result); // Output: [ 'key2', 'key3' ]
}
String.prototype.escape = function () {
  const entitiesToEscape = {
    "&": "&amp;",
    "<": "&lt;",
    ">": "&gt;",
    '"': "&quot;",
    "'": "&apos;",
    "\n": "<br>",
  };

  // Replace special characters with their corresponding HTML entities
  const escapedString = this.replace(/[&<>"'\n]/g, char => entitiesToEscape[char] || char);

  // Use DOMPurify for comprehensive HTML sanitization
  const sanitizedString = DOMPurify.sanitize(escapedString, { ALLOWED_TAGS: [] });

  // Replace newline characters with <br> for display in HTML
  const stringWithBr = sanitizedString.replace(/\n/g, "<br>");

  return stringWithBr;
};

String.prototype.unescapeWithTags = function () {
  const entitiesToReplace = {
    "&amp;": "&",
    "&lt;": "<",
    "&gt;": ">",
    "&quot;": '"',
    "&apos;": "'",
    "\n": "<br>",
  };

  const decodeEntities = html => {
    const doc = new DOMParser().parseFromString(html, "text/html");
    return doc.body.textContent;
  };

  let unescapedString = this;
  const tagsToCheck = ["&amp;", "&lt;", "&gt;", "&quot;", "&apos;", "\n"];
  while (tagsToCheck.some(tag => unescapedString.includes(tag))) {
    unescapedString = decodeEntities(unescapedString);
  }

  const sanitizedString = DOMPurify.sanitize(unescapedString, { ALLOWED_TAGS: [] });

  return sanitizedString.replace(/&lt;|&gt;|&quot;|&apos;|\n/g, entity => entitiesToReplace[entity] || entity);
};

String.prototype.unescape = function () {
  const entitiesToReplace = {
    "&amp;": "&",
    "&lt;": "<",
    "&gt;": ">",
    "&quot;": '"',
    "&apos;": "'",
    "\n": "<br>",
  };

  const decodeEntities = html => {
    const doc = new DOMParser().parseFromString(html, "text/html");
    return doc.body.textContent;
  };

  const sanitizedString = DOMPurify.sanitize(this, { ALLOWED_TAGS: [] });

  return decodeEntities(sanitizedString.replace(/&lt;|&gt;|&quot;|&apos;|\n/g, entity => entitiesToReplace[entity] || entity));
};

export const escapeString = string => {
  return string.escape();
};

export const unescapeString = string => {
  return string.unescape();
};
