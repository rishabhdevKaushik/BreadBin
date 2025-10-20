import { useRef, useState } from "react";
import { Dimensions, StyleSheet, View } from "react-native";
import { Gesture, GestureDetector } from "react-native-gesture-handler";
import Animated, {
  interpolate,
  runOnJS,
  useAnimatedStyle,
  useSharedValue,
  withSpring,
} from "react-native-reanimated";
import History from "./history";
import Input from "./input";

function TopContainer({ theme }) {
  const gestureRef = useRef();
  const styles = createStyles(theme);

  const [isExpanded, setIsExpanded] = useState(false);

  const { height: SCREEN_HEIGHT } = Dimensions.get("window");
  const COLLAPSED_HEIGHT = SCREEN_HEIGHT * 0.52;
  const EXPANDED_HEIGHT = SCREEN_HEIGHT * 0.92;
  const midpoint = (COLLAPSED_HEIGHT + EXPANDED_HEIGHT) / 2;
    // animation values
  const heightValue = useSharedValue(COLLAPSED_HEIGHT);
  const baseHeight = useSharedValue(COLLAPSED_HEIGHT);

    // scroll position (shared with child)
  const scrollY = useSharedValue(0);

  const parentGesture = Gesture.Pan()
    .onBegin(() => {
      baseHeight.value = heightValue.value;
    })
    .onUpdate((event) => {
          // ✅ Only allow dragging when the FlatList is scrolled to top
      if (scrollY.value <= 0) {

      let newHeight = baseHeight.value + event.translationY;
      heightValue.value = newHeight;

      // Determine expanded state based on midpoint crossing
      const shouldBeExpanded = newHeight > midpoint;
      // Update state if changed
      if (shouldBeExpanded !== isExpanded) {
        runOnJS(setIsExpanded)(shouldBeExpanded);
      }
    }
    })
    .onFinalize((event) => {
            // ✅ Only finalize when scroll is at top (avoid conflict)
      if (scrollY.value <= 0) {
      const velocityY = event.velocityY;
      if (Math.abs(velocityY) > 500) {
        // Snap on fast movement
        if (velocityY > 0) {
          runOnJS(setIsExpanded)(true);
          heightValue.value = withSpring(EXPANDED_HEIGHT);
        } else {
          runOnJS(setIsExpanded)(false);
          heightValue.value = withSpring(COLLAPSED_HEIGHT);
        }
      } else {
        // Snap based on whether current height is past midpoint
        if (heightValue.value > midpoint) {
          runOnJS(setIsExpanded)(true);
          heightValue.value = withSpring(EXPANDED_HEIGHT);
        } else {
          runOnJS(setIsExpanded)(false);
          heightValue.value = withSpring(COLLAPSED_HEIGHT);
        }
      }}
    }).withRef(gestureRef); ;

  // height animation
  const animatedStyles = useAnimatedStyle(() => {
    return {
      height: heightValue.value,
    };
  });

  // Fade Input/History
  const inputAnimatedStyle = useAnimatedStyle(() => ({
    opacity: interpolate(
      heightValue.value,
      [COLLAPSED_HEIGHT, midpoint, EXPANDED_HEIGHT],
      [1, 0.05, 0]
    ),
    // disable pointer events when invisible
    pointerEvents: heightValue.value > midpoint ? "none" : "auto",
  }));

  const historyAnimatedStyle = useAnimatedStyle(() => ({
    opacity: interpolate(
      heightValue.value,
      [COLLAPSED_HEIGHT, midpoint, EXPANDED_HEIGHT],
      [0, 0.05, 1]
    ),
    pointerEvents: heightValue.value > midpoint ? "auto" : "none",
  }));


  return (
    <GestureDetector gesture={parentGesture}>
      <Animated.View style={[styles.container, animatedStyles]}>
        {isExpanded ? (
          <Animated.View style={[{ flex: 1 }, historyAnimatedStyle]}>
            <History theme={theme} parentGestureRef={gestureRef} scrollY={scrollY}/>
          </Animated.View>
        ) : (
          <Animated.View style={[{ flex: 1 }, inputAnimatedStyle]}>
            <Input theme={theme} />
          </Animated.View>
        )}

        <View style={styles.line} />
      </Animated.View>
    </GestureDetector>
  );
}

function createStyles(theme) {
  return StyleSheet.create({
    container: {
      backgroundColor: theme.backgroundLight,
      justifyContent: "flex-end",
      width: "100%",
      position: "absolute",
      top: 0,
      zIndex: 10,
      borderBottomLeftRadius: 26,
      borderBottomRightRadius: 26,
      overflow: "hidden",
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
