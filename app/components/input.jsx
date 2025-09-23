import React from "react";
import { StyleSheet, Text, View } from "react-native";

function Input({ theme }) {
  const styles = createStyles(theme);
  return (
    <View style={styles.container}>
      <Text>Input</Text>
    </View>
  );
}

function createStyles(theme) {
  return StyleSheet.create({
    container: {
      padding: 20,
      alignItems: "center",
      flex: 1.2,
    },
    inputText: {
      fontSize: 32,
      marginBottom: 20,
    },
    row: {
      flexDirection: "row",
      marginBottom: 10,
    },
    button: {
      backgroundColor: theme.background,
      marginHorizontal: 10,
      borderRadius: 999,
      width: 60,
      height: 60,
      alignItems: "center",
      justifyContent: "center",
    },
    buttonText: {
      color: theme.text,
      fontSize: 36,
      fontWeight: 500,
    },
  });
}

export default Input;
