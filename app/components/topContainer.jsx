import React, { useEffect, useState } from "react";
import { Dimensions, StyleSheet, View } from "react-native";
import { Gesture, GestureDetector } from "react-native-gesture-handler";
import Animated, {
  useAnimatedStyle,
  useSharedValue,
  withSpring,
} from "react-native-reanimated";
import History from "./history";
import Input from "./input";

function TopContainer({ theme }) {
  const [isExpanded, setIsExpanded] = useState(false);
  const styles = createStyles(theme);

  const { height: SCREEN_HEIGHT } = Dimensions.get("window");
  const COLLAPSED_HEIGHT = SCREEN_HEIGHT * 0.52;
  const EXPANDED_HEIGHT = SCREEN_HEIGHT * 0.96;
  const heightValue = useSharedValue(COLLAPSED_HEIGHT);

  useEffect(() => {
    heightValue.value = withSpring(
      isExpanded ? EXPANDED_HEIGHT : COLLAPSED_HEIGHT
    );
  }, [isExpanded]);

  const gesture = Gesture.Pan()
    .onUpdate((event) => {
      // TODO: Add smooth scrolling
    })
    .onEnd((event) => {
      const velocityY = event.velocityY;
      console.log(velocityY);

      // On fast movement
      if (velocityY > 500) {
        setIsExpanded(true);
        return;
      } else if (velocityY < -500) {
        setIsExpanded(false);
        return;
      }
    });

  const animatedStyles = useAnimatedStyle(() => {
    return {
      height: heightValue.value,
    };
  });

  return (
    <GestureDetector gesture={gesture}>
      <Animated.View style={[styles.container, animatedStyles]}>
        {isExpanded ? <History theme={theme} /> : <Input theme={theme} />}
        <View style={styles.line} />
      </Animated.View>
    </GestureDetector>
  );
}

function createStyles(theme) {
  return StyleSheet.create({
    container: {
      backgroundColor: theme.backgroundLight,
      // paddingTop: 20,
      // alignItems: "center",
      // flex: 1,
      // alignSelf: "flex-start",
      justifyContent: "flex-end",
      width: "100%",
      height: "52%",
      position: "absolute",
      top: 0,
      zIndex: 10,

      borderBottomLeftRadius: 26,
      borderBottomRightRadius: 26,
    },
    line: {
      width: 75,
      height: 4,
      backgroundColor: theme.text,
      alignSelf: "center",
      marginVertical: 15,
      borderRadius: 25,
    },
  });
}

export default TopContainer;
