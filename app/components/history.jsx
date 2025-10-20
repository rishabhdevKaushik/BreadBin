import React, { useEffect, useRef, useState } from "react";
import { FlatList, StyleSheet, Text, View } from "react-native";
import { Gesture, GestureDetector } from "react-native-gesture-handler";
import { getTransactions } from "../utils/transactions";
import Animated, { useAnimatedScrollHandler } from "react-native-reanimated";

function History({ theme, parentGestureRef, scrollY }) {
  const styles = createStyles(theme);
  const [logs, setLogs] = useState([]);
  const flatListRef = useRef(null);

  useEffect(() => {
    async function fetchTransactions() {
      try {
        const transactions = await getTransactions();
        if (transactions && transactions.length > 0) {
          const parsedTransactions = await JSON.parse(transactions);
          // Sort by datetime ascending (oldest first, latest last)
          parsedTransactions.sort(
            (a, b) => new Date(b.datetime) - new Date(a.datetime)
          );
          setLogs(parsedTransactions);
        }
      } catch (error) {
        setLogs([]);
      }
    }
    fetchTransactions();
  }, []);

  const onScroll = useAnimatedScrollHandler({
    onScroll: (event) => {
      scrollY.value = event.contentOffset.y; // share scroll position with parent
    },
  });

  const nativeScroll = Gesture.Native().blocksExternalGesture(parentGestureRef);

  function getTime(datetime) {
    const date = new Date(datetime);
    let hours = date.getHours();
    const minutes = date.getMinutes().toString().padStart(2, "0");
    const ampm = hours >= 12 ? "PM" : "AM";
    hours = hours % 12;
    hours = hours ? hours : 12; // '0' should be '12'
    const time12hr = `${hours}:${minutes} ${ampm}`;
    return time12hr;
  }

  function scrollToEnd(shouldAnimate = false) {
    flatListRef.current?.scrollToBegin({ animated: shouldAnimate });
  }


  return (
    <View style={styles.container}>
      <GestureDetector gesture={nativeScroll}>
        <Animated.FlatList
          inverted={true}
          ref={flatListRef}
          data={logs}
          onScroll={onScroll}
          scrollEventThrottle={16}
          keyExtractor={(item, index) => index.toString()}
          renderItem={({ item }) => (
            <View style={styles.transaction}>
              <View>
                <Text
                  style={[
                    styles.text,
                    item?.type === "earning" && styles.earning,
                  ]}
                >
                  {item?.type === "earning" && "+ "}
                  {item.amount}
                </Text>
                <Text style={[styles.textLight]}>
                  {item.tags.map((tag, index) => (
                    <Text key={index} style={styles.textLight}>
                      {tag}
                      {index < item.tags.length - 1 ? ", " : ""}
                    </Text>
                  ))}
                </Text>
              </View>
              <Text style={[styles.textLight]}>{getTime(item.datetime)}</Text>
            </View>
          )}
          // onContentSizeChange={() => scrollToEnd(true)}
        />
      </GestureDetector>
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
    transaction: {
      // width: "70%",
      // alignSelf: "center",
      paddingHorizontal: 20,
      paddingVertical: 15,
      flexDirection: "row",
      justifyContent: "space-between",
    },
    text: {
      color: "white",
      fontSize: 20,
    },
    earning: {
      color: theme.earningText,
    },
    textLight: {
      color: theme.textLight,
    },
  });
}

export default History;
