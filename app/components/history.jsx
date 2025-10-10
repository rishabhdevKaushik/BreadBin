import React from "react";
import { StyleSheet, Text, View } from "react-native";

function History({ theme }) {
  const styles = createStyles(theme);
  return (
    // TODO: Add history functionality
    <View style={styles.container}>
      <Text style={styles.text}>History</Text>
    </View>
  );
}

function createStyles(theme) {
  return StyleSheet.create({
    container: {
      paddingTop: 20,
      alignItems: "center",
      justifyContent: "space-between",
      zIndex: 10,
      flex: 1,
      width: "100%",
      // height: "100%",
    },
    text: {
      color: "white",
    },
  });
}

export default History;
