import AntDesign from "@expo/vector-icons/AntDesign";
import FontAwesome6 from "@expo/vector-icons/FontAwesome6";
import React, { useRef, useState } from "react";
import {
  Animated,
  FlatList,
  StyleSheet,
  Text,
  TouchableOpacity,
  View,
} from "react-native";
import inputTypes from "../constants/inputType";
import { useInput, useInputType, useTotal } from "../utils/contexts";

function Input({ theme }) {
  const styles = createStyles(theme);
  const { inputType, setInputType } = useInputType();
  const { totalAmount } = useTotal();
  const { inputAmount } = useInput();

  const [isPopupVisible, setIsPopupVisible] = useState(false);
  const animation = useRef(new Animated.Value(0)).current;

  const togglePopup = () => {
    const toValue = isPopupVisible ? 0 : 1;
    Animated.timing(animation, {
      toValue,
      duration: 250,
      useNativeDriver: true,
    }).start(() => {
      setIsPopupVisible(!isPopupVisible);
    });
  };

  const onSelectType = (type) => {
    setInputType(type);
    Animated.timing(animation, {
      toValue: 0,
      duration: 250,
      useNativeDriver: true,
    }).start(() => {
      setIsPopupVisible(false);
    });
  };

  // Interpolated styles for popup and pill symbol
  const popupScale = animation.interpolate({
    inputRange: [0, 1],
    outputRange: [0.8, 1],
  });
  const popupOpacity = animation;
  const pillOpacity = animation.interpolate({
    inputRange: [0, 1],
    outputRange: [1, 0],
  });

  return (
    <View style={styles.container}>
      <View style={styles.totalContainer}>
        <View style={styles.topPill}>
          <Text style={styles.totalText}>Total</Text>
          <Text style={styles.totalTextAmount}>{totalAmount}</Text>
        </View>
        <FontAwesome6 name="gear" size={24} color={theme.text} />
      </View>

      {/* Select time and date */}
      <View style={styles.setDateTime}>
        <AntDesign name="clock-circle" size={24} color={theme.text} />
        <FontAwesome6 name="calendar" size={24} color={theme.text} />
      </View>

      {/* Input number */}
      <View style={styles.input}>
        <Text style={styles.inputText}>{inputAmount || 0}</Text>
      </View>

      {/* Change type and tags */}
      <View style={styles.inputDetails}>
        <View>
          <TouchableOpacity
            style={styles.typePill}
            onPress={togglePopup}
            activeOpacity={0.7}
          >
            <Animated.Text
              style={[styles.typePillText, { opacity: pillOpacity }]}
            >
              {inputType.symbol}
            </Animated.Text>
          </TouchableOpacity>

          <Animated.View
            style={[
              styles.popup,
              {
                opacity: popupOpacity,
                transform: [{ scale: popupScale }],
              },
            ]}
            pointerEvents={isPopupVisible ? "auto" : "none"}
          >
            <FlatList
              data={inputTypes}
              keyExtractor={(item) => item.type}
              renderItem={({ item }) => (
                <TouchableOpacity
                  style={styles.popupItem}
                  onPress={() => onSelectType(item)}
                >
                  <Text style={styles.popupItemText}>
                    {item.symbol} {item.type}
                  </Text>
                </TouchableOpacity>
              )}
            />
          </Animated.View>
        </View>

        <View style={styles.tagPill}>
          <AntDesign name="tags" size={20} color={theme.text} />
        </View>
      </View>
    </View>
  );
}

function createStyles(theme) {
  return StyleSheet.create({
    container: {
      backgroundColor: theme.backgroundLight,
      paddingTop: 20,
      alignItems: "center",
      justifyContent: "space-between",
      flex: 1,
      width: "100%",
      // height: "60",
      // borderBottomLeftRadius: 26,
      // borderBottomRightRadius: 26,
    },
    totalContainer: {
      width: "80%",
      flexDirection: "row",
      alignItems: "center",
      gap: 20,
    },
    topPill: {
      flex: 1,
      padding: "6%",
      paddingVertical: "2%",
      backgroundColor: theme.button,
      borderRadius: 200,
      flexDirection: "row",
      justifyContent: "space-between",
      alignItems: "center",
    },
    topPillText: {
      fontWeight: 700,
    },
    totalText: {
      fontSize: 28,
      fontWeight: 600,
      color: theme.text,
    },
    totalTextAmount: {
      fontSize: 28,
      fontWeight: 600,
      color: theme.text,
    },
    setDateTime: {
      width: "80%",
      flexDirection: "row",
      alignItems: "start",
      justifyContent: "flex-end",
      gap: 18,
    },
    input: {
      width: "80%",
      flexDirection: "row",
      alignItems: "center",
      justifyContent: "flex-end",
      gap: 18,
    },
    inputText: {
      color: theme.text,
      fontSize: 72,
      fontWeight: "500",
    },
    inputDetails: {
      width: "80%",
      flexDirection: "row",
      alignItems: "center",
      justifyContent: "space-between",
    },
    typePill: {
      height: 32,
      width: 48,
      backgroundColor: theme.button,
      borderRadius: 200,
      justifyContent: "center",
      alignItems: "center",
      color: theme.text,
    },
    typePillText: {
      color: theme.text,
      fontWeight: 600,
      fontSize: 24,
    },
    popup: {
      position: "absolute",
      top: 0, // adjust based on typePill size and spacing
      left: 0,
      backgroundColor: theme.button,
      borderRadius: 8,
      paddingVertical: 4,
      paddingHorizontal: 8,
      // shadowColor: "#000",
      // shadowOffset: { width: 0, height: 2 },
      // shadowOpacity: 0.3,
      // shadowRadius: 4,
      elevation: 5,
      zIndex: 10,
      minWidth: 140,
      transformOrigin: "top left",
    },
    popupItem: {
      paddingVertical: 8,
      paddingHorizontal: 12,
    },
    popupItemText: {
      color: theme.text,
      fontSize: 16,
    },
    tagPill: {
      height: 32,
      width: 48,
      backgroundColor: theme.button,
      borderRadius: 200,
      justifyContent: "center",
      alignItems: "center",
      color: theme.text,
    },
  });
}

export default Input;
