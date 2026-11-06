import { useEffect, useState } from 'react';
import { Button, Platform, StyleSheet, Text, View } from 'react-native';
import { FloadAttribution, VERSION } from '@fload-ai/attribution-react-native';

// The example only ever talks to the local ingest stub (`yarn stub` in the
// repo root), never to Fload. The Android emulator reaches the host at 10.0.2.2.
const STUB_ENDPOINT = Platform.select({
  android: 'http://10.0.2.2:3999',
  default: 'http://localhost:3999',
});
const EXAMPLE_KEY = 'fload_pk_example_local_stub';

FloadAttribution.configure(EXAMPLE_KEY, { endpoint: STUB_ENDPOINT, logLevel: 'debug' });
FloadAttribution.setUserId('example-user-1');

export default function App() {
  const [reference, setReference] = useState<string | null>(null);
  const [userIds, setUserIds] = useState(1);

  useEffect(() => {
    // The native SDK loads its state in the background, so ask again until it has one.
    const timer = setInterval(async () => {
      const value = await FloadAttribution.getInstallReference();
      if (value) {
        setReference(value);
        clearInterval(timer);
      }
    }, 250);
    return () => clearInterval(timer);
  }, []);

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Fload Attribution {VERSION}</Text>
      <Text>Sending to {STUB_ENDPOINT}</Text>
      <Text testID="install-reference">Install reference: {reference ?? 'loading…'}</Text>
      <Button
        title="Link another user id"
        onPress={() => {
          const next = userIds + 1;
          FloadAttribution.setUserId(`example-user-${next}`);
          setUserIds(next);
        }}
      />
    </View>
  );
}

const styles = StyleSheet.create({
  container: { flex: 1, alignItems: 'center', justifyContent: 'center', gap: 12, padding: 16 },
  title: { fontSize: 20, fontWeight: '600' },
});
