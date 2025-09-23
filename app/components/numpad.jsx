import Ionicons from "@expo/vector-icons/Ionicons";
import React from "react";
import { StyleSheet, Text, TouchableOpacity, View } from "react-native";

function Numpad({ theme }) {
  const numbers = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
    [0, "."],
  ];
  const specialButtons = [
    <Ionicons name="backspace" size={32} color="darkorange" />,
    <Ionicons name="checkmark" size={32} color="lightgreen" />,
  ];
  const styles = createStyles(theme);

  return (
    <View style={styles.container}>
      <View style={styles.numpadRow}>
        <View style={styles.numbersColumn}>
          {numbers.map((row, rowIndex) => (
            <View key={rowIndex} style={styles.row}>
              {row.map((num, index) => (
                <TouchableOpacity
                  key={index}
                  style={
                    num !== 0
                      ? styles.button
                      : [styles.button, styles.zeroButton]
                  }
                  onPress={() => {}}
                >
                  <Text style={styles.buttonText}>{num}</Text>
                </TouchableOpacity>
              ))}
            </View>
          ))}
        </View>

        <View style={styles.specialButtonsColumn}>
          {specialButtons.map((icon, index) => (
            <TouchableOpacity
              key={index}
              style={
                index !== 1 ? styles.button : [styles.button, styles.tickButton]
              }
              onPress={() => {}}
            >
              {icon}
            </TouchableOpacity>
          ))}
        </View>
      </View>
    </View>
  );
}

function createStyles(theme) {
  return StyleSheet.create({
    container: {
      padding: 20,
      alignItems: "center",
      flex: 1,
    },
    numpadRow: {
      flexDirection: "row",
      justifyContent: "center",
      alignItems: "center",
      gap: 10,
    },
    numbersColumn: {
      gap: 10,
    },
    specialButtonsColumn: {
      flexDirection: "column",
      alignItems: "center",
      gap: 10,
    },
    row: {
      flexDirection: "row",
      gap: 10,
    },
    button: {
      backgroundColor: theme.button,
      borderRadius: 999,
      width: 72,
      height: 72,
      alignItems: "center",
      justifyContent: "center",
    },
    buttonText: {
      color: theme.text,
      fontSize: 42,
      fontWeight: "500",
    },
    zeroButton: {
      width: 72 * 2 + 10, // Twice width of button + gap
    },
    tickButton: {
      height: 72 * 3 + 2 * 10, // Thrice height of button + twice gap
    },
  });
}

export default Numpad;
