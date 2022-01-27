document.addEventListener('turbolinks:load', (loadEvent) => {

  // SessionStorageの状態管理
  const IdStorage = () => {
    let ids = sessionStorage.getItem('ids')?.split(',').filter(id => id !== '') || [];

    const isExists = (id) => ids.includes(id);

    const save = () => {
      sessionStorage.setItem('ids', ids);
      console.log(ids);
      return ids;
    }

    const reset = () => {
      sessionStorage.removeItem('ids');
    }

    const add = (thisId) => {
      if (!isExists(thisId))
        ids = [thisId, ...ids];
      save();
    }

    const remove = (thisId) => {
      ids = ids.filter(id => id !== thisId);
      save();
    }

    const count = () => {
      return ids.length;
    }

    return { reset, add, remove, isExists, count };
  }

  // initialize
  const idStorage = IdStorage();


  // １つのチェックボックス
  const Checkbox = (node, handleOnCheck, handleOnUncheck) => {
    const value = node.value;

    const check = () => {
      node.checked = true;
      handleOnCheck();
    }
    const uncheck = () => {
      node.checked = false;
      handleOnUncheck();
    }

    const isChecked = () => {
      return node.checked;
    }

    return { node, value, check, uncheck, isChecked }
  }


  // initialize: Checkboxes
  const checkboxes = Array.from(document.querySelectorAll('.check')).map(
      (node) => {
        const handleOnCheck = () => {
          idStorage.add(node.value);
          checkingCounter.update(idStorage.count());
        };

        const handleOnUncheck = () => {
          idStorage.remove(node.value);
          checkingCounter.update(idStorage.count());
        };

        const checkbox = Checkbox(node, handleOnCheck, handleOnUncheck);
        if (idStorage.isExists(checkbox.value)) node.checked = true;

        node.addEventListener('change', () => {
          node.checked ? checkbox.check() : checkbox.uncheck();
        })

        return checkbox
    });



  // 全選択チェックボックス
  const AllChecker = (node, checkboxes) => {
    const check = () => {
      node.checked = true;
      checkboxes.forEach(checkbox => checkbox.check())
    }

    const uncheck = () => {
      node.checked = false;
      checkboxes.forEach(checkbox => checkbox.uncheck())
    }

    const isCheckingAll = () => checkboxes.every(checkbox => checkbox.isChecked());

    const handleOnAllCheckboxes = () => node.checked = isCheckingAll();

    checkboxes.forEach(checkbox => checkbox.node.addEventListener('change', handleOnAllCheckboxes))

    return { check, uncheck, isCheckingAll }
  }

  const allCheckerNode = document.querySelector('.all-checker');


  // initialize allChecker
  const allChecker = AllChecker(allCheckerNode, checkboxes);

  allCheckerNode.addEventListener('change', () => {
    allCheckerNode.checked ? allChecker.check() : allChecker.uncheck();
  });



  // カウント表示
  // 条件に応じてアラート表示
  const CheckingCounter = (counterNodes, alertNode, messageNode, allChecker) => {
    let size = 0;
    const allIdsCount = Number(document.querySelector('#all-ids-count').value);

    const showAlert = () => {
      alertNode.classList.add('shown');
      alertNode.classList.remove('hidden');
    }

    const hideAlert = () => {
      alertNode.classList.add('hidden');
      alertNode.classList.remove('shown');
    }

    const setMessage = (message) => messageNode.innerText = message;

    const update = (newSize) => {
      size = newSize;
      counterNodes.forEach(elem => elem.innerHTML = newSize.toLocaleString());
      allChecker.isCheckingAll() ? showAlert() : hideAlert();
      size == allIdsCount ? setMessage('選択解除') : setMessage(`${ allIdsCount.toLocaleString() } 件すべてを選択`);
      return size;
    }


    const handleOnClick = (event) => {
      size == allIdsCount ? allChecker.uncheck() : update(allIdsCount);
      event.preventDefault();
    }

    setMessage(`${ allIdsCount.toLocaleString() } 件すべてを選択`);
    update(idStorage.count());
    messageNode.addEventListener('click', handleOnClick);

    return { update }
  }

  // initialize: CheckingCounters
  const checkingCounter = CheckingCounter(
    Array.from(document.querySelectorAll(".selected-size")),
    document.querySelector('.checking-all-pages-alert'),
    document.querySelector('.checking-all-pages-alert-message'),
    allChecker,
  );



  // ターボリンクスのロード時に実行。URIがアンバサダー一覧ページでない場合はSessionStorageをリセット
  const uri = loadEvent.target.baseURI;
  if(!uri.includes('ambassadors')) idStorage.reset();
}, { once: true })