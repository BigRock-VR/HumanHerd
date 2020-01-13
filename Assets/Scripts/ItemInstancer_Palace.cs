using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/* assicurarsi di avere questa nomenclatura, le varianti devono chiamarsi nello stesso modo :
  ~ NOME DEL MODELLO (Lo script e' qui')
    - PianoTerra
    - Cornicione
    - SecondoPiano
    - Tetto

    
*/

public class ItemInstancer_Palace : MonoBehaviour
{
    [Header("Floors Range")]
    [SerializeField][Range(1,10)]
    int maxFloors, minFloors;

    [SerializeField]
    List<GameObject> GOsInScene;

    [SerializeField]List<GameObject> grounds;
    [SerializeField]List<GameObject> cornices;
    [SerializeField]List<GameObject> floors;
    [SerializeField]List<GameObject> roofs;

    void Start()
    {

        for (int i = 0; i <= transform.childCount-1; i++)
        {
            var child = transform.GetChild(i);
            GOsInScene.Add(child.gameObject);

            
            CheckName(child.name, child.gameObject);

            if(i==transform.childCount-1)
            {
                RandomSelect();
                return;
            }
        }
    }

    void CheckName(string name, GameObject go)
    {
        if(name == "PianoTerra")
        {
            grounds.Add(go);
        }
        if (name == "Cornicione")
        {
            cornices.Add(go);
        }
        if (name == "SecondoPiano")
        {
            floors.Add(go);
        }
        if (name == "Tetto")
        {
            roofs.Add(go);
        }
    }

    void PlaceItems()
    {
        for (int i = 0; i <= GOsInScene.Count-1; i++)
        {
            if(i == 0)
            {
                GOsInScene[i].transform.localPosition = Vector3.zero;
            }
            else
            {
                // getting highest vertex of previous mesh
                List<Vector3> vList = new List<Vector3>();
                var mrGO = GOsInScene[i - 1].GetComponent<MeshFilter>();
                var topV = float.MinValue;
                Vector3 finalOffset = new Vector3();
                int random = Random.Range(0, 4);
                Vector3 finalRot = new Vector3(0,0,0);

                mrGO.mesh.GetVertices(vList);
                for (int x = 0; x < vList.Count; x++)
                {
                    if(vList[x].y > topV)
                    {
                        topV = vList[x].y;
                    }

                    if(x == vList.Count-1)
                    {
                        finalOffset = GOsInScene[i - 1].transform.localPosition;
                        finalOffset.y += topV;


                        finalRot.y = finalRot.y + (90 * random);

                        //print(i);
                    }
                }

                GOsInScene[i].transform.Rotate(finalRot);
                GOsInScene[i].transform.localPosition = finalOffset;
                GOsInScene[i].gameObject.isStatic = true;
            }

        }
    }

    public void updateRoomsMeshes()
    {
        var x = FindObjectsOfType<ItemInstancer_Palace>();
        foreach(ItemInstancer_Palace instances in x)
        {
            instances.gameObject.isStatic = false;
            instances.RandomSelect();
        }
    }

    public void RandomSelect()
    {
        int floorsAmount = Random.Range(minFloors, maxFloors+1);
        bool isCheching = false;
        //print(floorsAmount);
        var gInst = grounds[Random.Range(0, grounds.Count)].GetComponent<MeshRenderer>();
        var cInst = cornices[Random.Range(0, cornices.Count)].GetComponent<MeshRenderer>();
        var fInst = floors[Random.Range(0, floors.Count)].GetComponent<MeshRenderer>();
        var rInst = roofs[Random.Range(0, roofs.Count)].GetComponent<MeshRenderer>();

        foreach(GameObject go in GOsInScene)
        {
            go.GetComponent<MeshRenderer>().enabled = false;
        }
        GOsInScene.Clear();
        

        gInst.enabled = true;
        GOsInScene.Add(gInst.gameObject);

        if (floorsAmount == 1 && !isCheching)
        {
            print("1 floor");
            rInst.enabled = true;
            GOsInScene.Add(rInst.gameObject);
        }
        else if (floorsAmount > 1 && !isCheching)
        {
            isCheching = true;
            for (int i = 0; i < floorsAmount-1; i++)
            {
                
                if (cInst.enabled == true)
                {
                    var newCInst = Instantiate(cInst, transform);
                    newCInst.enabled = true;
                    cInst = newCInst;
                }
                if (fInst.enabled == true)
                {
                    var newFInst = Instantiate(fInst, transform);
                    newFInst.enabled = true;
                    fInst = newFInst;
                }

                cInst.enabled = true;
                fInst.enabled = true;

                GOsInScene.Add(cInst.gameObject);
                GOsInScene.Add(fInst.gameObject);
                isCheching = false;

                if (i == floorsAmount-2)
                {

                    rInst.enabled = true;
                    GOsInScene.Add(rInst.gameObject);
                    isCheching = false;
                }

            }

        }
        PlaceItems();
    }
}
