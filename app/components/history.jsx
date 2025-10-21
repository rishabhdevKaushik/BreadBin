import AntDesign from "@expo/vector-icons/AntDesign";
import React, { useEffect, useRef, useState } from "react";
import { StyleSheet, Text, TouchableOpacity, View } from "react-native";
import { Gesture, GestureDetector } from "react-native-gesture-handler";
import Animated, {
  runOnJS,
  useAnimatedScrollHandler,
  useSharedValue,
} from "react-native-reanimated";
import { getTransactions } from "../utils/transactions";

function getTime(datetime) {
  const date = new Date(datetime);
  let hours = date.getHours();
  const minutes = date.getMinutes().toString().padStart(2, "0");
  const ampm = hours >= 12 ? "PM" : "AM";
  hours = hours % 12 || 12;
  return `${hours}:${minutes} ${ampm}`;
}

function getDateString(datetime) {
  const date = new Date(datetime);
  const weekdays = [
    "Sunday",
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];
  const dayName = weekdays[date.getDay()];
  const dayNumber = date.getDate();
  return `${dayName}, ${dayNumber}`;
}

function getMonthString(datetime) {
  const date = new Date(datetime);
  const monthNames = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "June",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];
  const monthName = monthNames[date.getMonth()];
  const year = date.getFullYear();
  return `${monthName} ${year}`;
}

function flattenTransactions(transactions) {
  const groupedByMonth = {};

  transactions.forEach((t) => {
    const month = getMonthString(t.datetime);
    if (!groupedByMonth[month]) groupedByMonth[month] = {};

    const day = getDateString(t.datetime);
    if (!groupedByMonth[month][day]) groupedByMonth[month][day] = [];

    groupedByMonth[month][day].push(t);
  });

  const flatListData = [];
  const months = Object.keys(groupedByMonth).sort(
    (a, b) => new Date(b) - new Date(a)
  );

  months.forEach((month) => {
    const days = Object.keys(groupedByMonth[month]).sort(
      (a, b) => new Date(b) - new Date(a)
    );

    days.forEach((day) => {
      groupedByMonth[month][day].forEach((tx, idx) =>
        flatListData.push({ type: "item", ...tx, key: `item-${day}-${idx}` })
      );
      flatListData.push({ type: "day", title: day, key: `day-${day}` });
    });
    flatListData.push({ type: "month", title: month, key: `month-${month}` });
  });

  return flatListData;
}

function History({ theme, parentGestureRef, scrollY }) {
  const styles = createStyles(theme);
  const [data, setData] = useState([]);
  const flatListRef = useRef(null);
  const [showScrollButton, setShowScrollButton] = useState(false);

  const localScrollY = useSharedValue(0);

  useEffect(() => {
    async function fetchTransactions() {
      try {
        const transactions = await getTransactions();
        if (transactions?.length > 0) {
          const parsed = JSON.parse(transactions);
          parsed.sort((a, b) => new Date(b.datetime) - new Date(a.datetime));
          setData(flattenTransactions(parsed));
        }
      } catch (error) {
        setData([]);
      }
    }
    fetchTransactions();
  }, []);

  const onScroll = useAnimatedScrollHandler({
    onScroll: (event) => {
      // Update the shared values
      localScrollY.value = event.contentOffset.y;
      scrollY.value = event.contentOffset.y;

      // Show or hide the button on the JS thread
      if (event.contentOffset.y > 50) {
        runOnJS(setShowScrollButton)(true);
      } else {
        runOnJS(setShowScrollButton)(false);
      }
    },
  });

  const nativeScroll = Gesture.Native().blocksExternalGesture(parentGestureRef);

  function scrollToEnd(shouldAnimate = true) {
    flatListRef.current?.scrollToOffset({ offset: 0, animated: shouldAnimate });
  }

  function renderItem({ item }) {
    if (item.type === "month") {
      return (
        <View style={styles.monthContainer}>
          <Text style={styles.monthText}>{item.title}</Text>
        </View>
      );
    }

    if (item.type === "day") {
      return (
        <View style={styles.dayContainer}>
          <Text style={styles.dayText}>{item.title}</Text>
        </View>
      );
    }

    return (
      <View style={styles.transaction}>
        <View>
          <Text
            style={[styles.text, item?.type === "earning" && styles.earning]}
          >
            {item?.type === "earning" && "+ "}
            {item.amount}
          </Text>
          <Text style={styles.textLight}>
            {item?.tags?.map((tag, idx) => (
              <Text key={idx} style={styles.textLight}>
                {tag}
                {idx < item.tags.length - 1 ? ", " : ""}
              </Text>
            ))}
          </Text>
        </View>
        <Text style={styles.textLight}>{getTime(item.datetime)}</Text>
      </View>
    );
  }

  return (
    <View style={styles.container}>
      <GestureDetector gesture={nativeScroll}>
        <Animated.FlatList
          inverted={true}
          ref={flatListRef}
          data={data}
          onScroll={onScroll}
          scrollEventThrottle={16}
          keyExtractor={(item, index) => index.toString()}
          renderItem={renderItem}
          // onContentSizeChange={() => scrollToEnd(true)}
        />
      </GestureDetector>

      {showScrollButton && (
        <TouchableOpacity
          style={styles.scrollButton}
          onPress={() => scrollToEnd()}
        >
          {/* <Text style={styles.scrollButtonText}>↓</Text> */}
          <AntDesign name="arrow-down" size={24} color={theme.text} />
        </TouchableOpacity>
      )}
    </View>
  );
}

function createStyles(theme) {
  return StyleSheet.create({
    container: {
      paddingTop: 20,
      // alignItems: "center",
      // justifyContent: "space-between",
      zIndex: 10,
      flex: 1,
      width: "100%",
      // height: "100%",
    },
    monthContainer: {
      paddingVertical: 10,
      paddingHorizontal: 16,
    },
    monthText: {
      color: theme.text,
      fontWeight: "bold",
      fontSize: 18,
    },
    dayContainer: {
      paddingVertical: 8,
      paddingHorizontal: 16,
    },
    dayText: {
      color: theme.textLight,
      fontWeight: "bold",
      fontSize: 16,
    },
    transaction: {
      // width: "70%",
      // alignSelf: "center",
      paddingHorizontal: 20,
      paddingVertical: 15,
      flexDirection: "row",
      justifyContent: "space-between",
    },
    text: {
      color: theme.text,
      fontSize: 20,
    },
    earning: {
      color: theme.earningText,
    },
    textLight: {
      color: theme.textLight,
    },
    scrollButton: {
      position: "absolute",
      bottom: 30,
      right: 20,
      backgroundColor: theme.background,
      // paddingVertical: 10,
      // paddingHorizontal: 15,
      width: 60,
      height: 60,
      borderRadius: 10,
      zIndex: 20,
      elevation: 5,
      alignItems: "center",
      justifyContent: "center",
    },
  });
}

export default History;
