{-# LANGUAGE OverloadedStrings #-}

import Control.Monad.State.Lazy
import Data.List
import Data.Semigroup ((<>))
import Lens.Micro.Platform ((.=))
import System.Environment

import Yi
import Yi.Fuzzy
import Yi.Config.Simple.Types
import Yi.Config.Default.HaskellMode (configureHaskellMode)
import Yi.Config.Default.MiscModes (configureMiscModes)
import Yi.Config.Default.Vty
import qualified Yi.Keymap.Vim as V
import qualified Yi.Config.Default.Vim as V (configureVim)
import qualified Yi.Keymap.Vim.Common as V
import qualified Yi.Keymap.Vim.Ex.Types as V
import qualified Yi.Keymap.Vim.Ex.Commands.Common as V
import qualified Yi.Keymap.Vim.Utils as V
import qualified Yi.Mode.Haskell as Haskell

myKeymapSet :: KeymapSet
myKeymapSet = V.mkKeymapSet $ V.defVimConfig `override` \super this ->
    let eval = V.pureEval this
    in super {
          -- Here we can add custom bindings.
          -- See Yi.Keymap.Vim.Common for datatypes and
          -- Yi.Keymap.Vim.Utils for useful functions like mkStringBindingE

          -- In case of conflict, that is if there exist multiple bindings
          -- whose prereq function returns WholeMatch,
          -- the first such binding is used.
          -- So it's important to have custom bindings first.
          V.vimBindings = myBindings eval <> V.vimBindings super
        }

myBindings :: (V.EventString -> EditorM ()) -> [V.VimBinding]
myBindings eval =
    let nmap  x y = V.mkStringBindingE V.Normal V.Drop (x, y, id)
        nmap' x y = V.mkStringBindingY V.Normal (x, y, id)
        imap  x y = V.VimBindingE (\evs state -> case V.vsMode state of
                                    V.Insert _ ->
                                        fmap (const (y >> return V.Continue))
                                             (evs `V.matchesString` x)
                                    _ -> V.NoMatch)
    in [ nmap  "<C-h>" previousTabE
       , nmap  "<C-l>" nextTabE
       , nmap' "<C-p>" fuzzyOpen
       ]

configureVim = do
  V.configureVim
  defaultKmA .= myKeymapSet

myConfig :: ConfigM ()
myConfig = do
    configureVty
    configureVim
    configureHaskellMode
    configureMiscModes

main :: IO ()
main = do
    files <- getArgs
    let openFileActions = intersperse (EditorA newTabE) (map (YiA . openNewFile) files)
    cfg <- execStateT
        (runConfigM (myConfig >> (startActionsA .= openFileActions)))
        defaultConfig
    startEditor cfg Nothing
