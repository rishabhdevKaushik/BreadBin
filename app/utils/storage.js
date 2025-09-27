import AsyncStorage from "@react-native-async-storage/async-storage";

function changeToString(value) {
  if (typeof value !== "string"  && !(value instanceof String)) {
    // console.log("change to string");
    return value.toString();
  } else {
    return value;
  }
}

export async function setValue(key, value) {
  try {
    key = changeToString(key);
    value = changeToString(value);
    await AsyncStorage.setItem(key, value);
  } catch (e) {
    console.log("Error occured while saving in storage\nError : ", e);
  }
}

export async function getValue(key) {
  try {
    key = changeToString(key);
    const value = await AsyncStorage.getItem(key);
    return value;
  } catch (e) {
    console.log("Error occured while saving in storage\nError : ", e);
  }
}
