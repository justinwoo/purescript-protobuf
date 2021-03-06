-- | Primitive UInt-based builders for encoding Google Protocol Buffers.
-- |
-- | There is no `varint32` in the Protbuf spec, this is
-- | just a performance-improving assumption we make
-- | in cases where only a deranged lunatic would use a value
-- | bigger than 32 bits, such as in field numbers.
-- | We think this is worth the risk because `UInt` is
-- | represented as a native Javascript Number whereas
-- | `Long` is a composite library type, so we expect the
-- | performance difference to be significant.
module Protobuf.Encode32
( zigzag32
, tag32
, varint32
)
where

import Prelude
import Effect.Class (class MonadEffect)
import Data.ArrayBuffer.Builder as Builder
import Data.UInt (UInt, fromInt, (.&.), (.|.), (.^.), shl, shr, zshr)
import Data.Enum (fromEnum)
import Protobuf.Common (FieldNumber, WireType)


-- | https://developers.google.com/protocol-buffers/docs/encoding#signed_integers
zigzag32 :: Int -> UInt
zigzag32 n = let n' = fromInt n in (n' `shl` (fromInt 1)) .^. (n' `shr` (fromInt 31))

-- | https://developers.google.com/protocol-buffers/docs/encoding#structure
tag32 :: forall m. MonadEffect m => FieldNumber -> WireType -> Builder.PutM m Unit
tag32 fieldNumber wireType =
  varint32 $ (fieldNumber `shl` (fromInt 3)) .|. (fromInt $ fromEnum wireType)

-- | https://developers.google.com/protocol-buffers/docs/encoding#varints
varint32 :: forall m. MonadEffect m => UInt -> Builder.PutM m Unit
varint32 n_0 = do
  let group_0 = n_0 .&. u0x7F
      n_1     = n_0 `zshr` u7
  if n_1 == u0
    then Builder.putUint8 group_0
    else do
      Builder.putUint8 $  u0x80 .|. group_0
      let group_1 = n_1 .&. u0x7F
          n_2     = n_1 `zshr` u7
      if n_2 == u0
        then Builder.putUint8 group_1
        else do
          Builder.putUint8 $ u0x80 .|. group_1
          let group_2 = n_2 .&. u0x7F
              n_3     = n_2 `zshr` u7
          if n_3 == u0
            then Builder.putUint8 group_2
            else do
              Builder.putUint8 $ u0x80 .|. group_2
              let group_3 = n_3 .&. u0x7F
                  n_4     = n_3 `zshr` u7
              if n_4 == u0
                then Builder.putUint8 group_3
                else do
                  Builder.putUint8 $ u0x80 .|. group_3
                  Builder.putUint8 n_4
 where
  u0    = fromInt 0
  u7    = fromInt 7
  u0x7F = fromInt 0x7F
  u0x80 = fromInt 0x80

